

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
	void poner_ingrediente(int i);
	void obtener_ingrediente(int  i);
	void esperar_recogida_ingrediente();
};

Estanco::Estanco(){
	estanquero = newCondVar();
	for(int i=0;i<num_fumadores;i++){
		fumador[i]=newCondVar();
	}
	ingrediente = -1;
}
void Estanco::poner_ingrediente(int i){
	cout<<"puesto el ingrediente "<< i <<endl;
	if(!fumador[i].empty()){
		fumador[i].signal();
	}
}
void Estanco::obtener_ingrediente(int i){
   if(ingrediente!=i){
		fumador[i].wait();
	}
	ingrediente =-1;
	cout << "fumador coge el ingrediente " << i << endl;
	estanquero.signal();
}
void Estanco::esperar_recogida_ingrediente(){
   if(ingrediente >=0){
		estanquero.wait();
	}
}
void funcion_hebra_estanquero(MRef<Estanco>monitor){
	int ingrediente;
	while (true) {
 		ingrediente = producir_ingrediente();
		monitor->poner_ingrediente(ingrediente);
		monitor->esperar_recogida_ingrediente();
	}
}
void funcion_hebra_fumador(int num_fumador,MRef<Estanco>monitor){
	while(true){
		monitor->obtener_ingrediente(num_fumador);
		fumar(num_fumador);
	}
}

int main (int argc, char *argv[]) {
	MRef<Estanco>monitor = Create<Estanco>();
	thread fumadores[num_fumadores];
	thread estanquero = thread(funcion_hebra_estanquero,monitor);
	for (int i = 0; i < num_fumadores; i++){
		fumadores[i]=thread(funcion_hebra_fumador,i,monitor);
	}
	for (int i = 0; i < num_fumadores; i++){
		fumadores[i].join();
	}
	estanquero.join();

	return 0;
}
