#include <iostream>
#include <iomanip>
#include <cassert>
#include <random>
#include <thread>
#include "scd.h"

using namespace std ;
using namespace scd ;

constexpr int               
   min_ms    = 5,     // tiempo minimo de espera en sleep_for
   max_ms    = 20 ;   // tiempo máximo de espera en sleep_for

// *****************************************************************************
// clase para monitor buffer, version FIFO, semántica SC, multiples prod/cons

class Lec_Esc : public HoareMonitor
{
 private:
 int n_lec;
 bool escrib;
 CondVar         // colas condicion:
   lectura,
   escritura;
                

 public:                    // constructor y métodos públicos
   Lec_Esc();
   void ini_lectura(int id), fin_lectura(int id), ini_escritura(int id), fin_escritura(int id);
                // constructor

} ;
// -----------------------------------------------------------------------------

Lec_Esc::Lec_Esc(  )
{
   n_lec = 0 ;
   escrib = false ;
   lectura = newCondVar();
    escritura = newCondVar();
}


void Lec_Esc::ini_lectura(int id){
    if(escrib)
        lectura.wait();
    n_lec++;
    cout << "El lector " << id << " acaba de empezar a leer" << endl;
    lectura.signal();
}

void Lec_Esc::fin_lectura(int id){
    n_lec--;
    cout << "El lector " << id << " acaba de terminar de leer" << endl;
    if(n_lec == 0)
        escritura.signal();
}

void Lec_Esc::ini_escritura(int id){
    if(n_lec > 0 || escrib)
        escritura.wait();
    cout << "El escritor " << id << " acaba de empezar a escribir" << endl;
    escrib = true;
}

void Lec_Esc::fin_escritura(int id){
    cout << "El escritor " << id << " acaba de terminar de escribir" << endl;
    escrib = false;
    if (!lectura.empty())
        lectura.signal();
    else
        escritura.signal();
}


void Lector(MRef<Lec_Esc> monitor, int i){
    while(true){
        monitor->ini_lectura(i);
        this_thread::sleep_for( chrono::milliseconds( aleatorio<min_ms,max_ms>() ));
        monitor->fin_lectura(i);
        this_thread::sleep_for( chrono::milliseconds( aleatorio<min_ms,max_ms>() ));
    }
}

void Escritor(MRef<Lec_Esc> monitor, int i){
    while(true){
        monitor->ini_escritura(i);
        this_thread::sleep_for( chrono::milliseconds( aleatorio<min_ms,max_ms>() ));
        monitor->fin_escritura(i);
        this_thread::sleep_for( chrono::milliseconds( aleatorio<min_ms,max_ms>() ));
    }
}

const int NUM_ESCRITORES = 4;
const int NUM_LECTORES = 4;
int main(){


     // crear monitor  ('monitor' es una referencia al mismo, de tipo MRef<...>)
   MRef<Lec_Esc> monitor = Create<Lec_Esc>() ;
   thread escritores[NUM_ESCRITORES];
   thread lectores[NUM_LECTORES];
   for (int i = 0; i < NUM_ESCRITORES; i++)
      escritores[i] = thread(Escritor, monitor, i);
   for (int i = 0; i < NUM_LECTORES; i++)
      lectores[i] = thread(Lector, monitor, i);

   
   for (int i = 0; i < NUM_ESCRITORES; i++)
      escritores[i].join();

   for (int i = 0; i < NUM_LECTORES; i++)
      lectores[i].join();

 
    return 0;
}