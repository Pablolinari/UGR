

#include <iostream>
#include <iomanip>
#include <cassert>
#include <locale>
#include <random>
#include <thread>
#include "scd.h"

using namespace std ;
using namespace scd ;

const int num_fumadores = 3 ; 

int producir_ingrediente()
{
   // calcular milisegundos aleatorios de duración de la acción de fumar)
   chrono::milliseconds duracion_produ( aleatorio<10,100>() );

   // informa de que comienza a producir
   cout << "Estanquero : empieza a producir ingrediente (" << duracion_produ.count() << " milisegundos)" << endl;

   // espera bloqueada un tiempo igual a ''duracion_produ' milisegundos
   this_thread::sleep_for( duracion_produ );

   const int num_ingrediente = aleatorio<0,num_fumadores-1>() ;

   // informa de que ha terminado de producir
   cout << "Estanquero : termina de producir ingrediente " << num_ingrediente << endl;

   return num_ingrediente ;
}

void fumar( int num_fumador )
{

   // calcular milisegundos aleatorios de duración de la acción de fumar)
   chrono::milliseconds duracion_fumar( aleatorio<20,200>() );

   // informa de que comienza a fumar

    cout << "Fumador " << num_fumador << "  :"
          << " empieza a fumar (" << duracion_fumar.count() << " milisegundos)" << endl;

   // espera bloqueada un tiempo igual a ''duracion_fumar' milisegundos
   this_thread::sleep_for( duracion_fumar );

   // informa de que ha terminado de fumar

    cout << "Fumador " << num_fumador << "  : termina de fumar, comienza espera de ingrediente." << endl;

}
class estanco : public HoareMonitor{
private:
	int ingrediente;
	CondVar mostrador;
	CondVar fumadores[num_fumadores];
public:
	void obteneringrediente(int i);
	void poneringrediente(int i );
	void esperarecogidaingrediente();
	estanco();
};
estanco::estanco(){
	ingrediente = -1;
	for (int i = 0; i<num_fumadores;i++){
		fumadores[i]= newCondVar();
	}
	mostrador = newCondVar();
}
void estanco::obteneringrediente(int i){
	if(ingrediente != i){
		fumadores[i].wait();
	}
	ingrediente = -1;
	mostrador.signal();
}
void estanco::poneringrediente(int i){
	ingrediente=i;
	fumadores[i].signal();
}
void estanco::esperarecogidaingrediente(){
	while(ingrediente != -1){
		mostrador.wait();
	}
}

void hebraestanquero(MRef<estanco>monitor){
	int ingrediente;
	while (true) {

		ingrediente = producir_ingrediente();
		monitor->poneringrediente(ingrediente);
		monitor->esperarecogidaingrediente();
	}
}
void hebrafumador(int i,MRef<estanco>monitor){
	while (true) {
		monitor->obteneringrediente(i);
		fumar(i);
	
	}
}

int main (int argc, char *argv[]) {
	MRef<estanco> monitor = Create<estanco>();
	thread estanquero = thread(hebraestanquero,monitor);
	thread fumadores[num_fumadores];
	for (int i = 0; i< num_fumadores;i++){
		fumadores[i] = thread(hebrafumador,i,monitor);
	}
	for (int i = 0; i< num_fumadores;i++){
		fumadores[i].join();
	}
	estanquero.join();
	return 0;
}
