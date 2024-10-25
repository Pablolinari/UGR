

#include <iostream>
#include <iomanip>
#include <cassert>
#include <locale>
#include <random>
#include <thread>
#include "scd.h"

using namespace std ;
using namespace scd ;


const int num_fumadores = 3;



//-------------------------------------------------------------------------
// Función que simula la acción de producir un ingrediente, como un retardo
// aleatorio de la hebra (devuelve número de ingrediente producido)

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

class Estanco : public HoareMonitor{
private:
	int ingrediente;
	 CondVar estanquero //cola donde espera el estanquero 
	,fumador[num_fumadores];// cola donde esperan los fumadores 
public:
	Estanco();
	int poner_ingrediente(int i);
	int obtener_ingrediente(int  i);
	void esperar_recogida_ingrediente();
};

Estanco::Estanco(){
	estanquero = newCondVar();
	for(int i=0;i<num_fumadores;i++){
		fumador[i]=newCondVar();
	}
}
int Estanco::poner_ingrediente(int i){
	
}

void funcion_hebra_estanquero(){

}
void funcion_hebra_fumador(int num_fumador){

}
