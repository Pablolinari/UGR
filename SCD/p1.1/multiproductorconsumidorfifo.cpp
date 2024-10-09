#include <atomic>
#include <iostream>
#include <cassert>
#include <thread>
#include <mutex>
#include <random>
#include "scd.h"

using namespace std ;
using namespace scd ;

//**********************************************************************
// Variables globales
const int HEBRASCONSUMIDORAS = 2;
const int HEBRASPRODUCTORAS = 4;
const unsigned 
   num_items = 40 ,   // número de items
	tam_vec   = 10 ;   // tamaño del buffer
unsigned  
   cont_prod[num_items] = {0}, // contadores de verificación: para cada dato, número de veces que se ha producido.
   cont_cons[num_items] = {0}, // contadores de verificación: para cada dato, número de veces que se ha consumido.
   siguiente_dato       = 0 ; // siguiente dato a producir en 'producir_dato' (solo se usa ahí)
unsigned buffer[tam_vec];
Semaphore puede_leer(0);
Semaphore puede_escribir(tam_vec);
Semaphore cambiaindice(1);
Semaphore cambiaindice1(1);
int primera_ocupada=0;
int primera_libre = 0;
int producidos[HEBRASPRODUCTORAS]={0};
int p = num_items/HEBRASPRODUCTORAS;

//**********************************************************************
// funciones comunes a las dos soluciones (fifo y lifo)
//----------------------------------------------------------------------

unsigned producir_dato(int i)
{

   this_thread::sleep_for( chrono::milliseconds( aleatorio<20,100>() ));
	int dato_producido = i*p + producidos[i];
   producidos[i]+=1;
   cont_prod[dato_producido]++;
   cout <<"hebra :"<<i<< " producido: " << dato_producido << endl << flush ;
   return dato_producido ;
}
//----------------------------------------------------------------------

void consumir_dato( unsigned dato , int i)
{
   assert( dato < num_items );
   cont_cons[dato] ++ ;	
   this_thread::sleep_for( chrono::milliseconds( aleatorio<20,100>() ));
	
   cout << "                  consumido: " << dato << endl ;

}


//----------------------------------------------------------------------

void test_contadores()
{
   bool ok = true ;
   cout << "comprobando contadores ...." ;
   for( unsigned i = 0 ; i < num_items ; i++ )
   {  if ( cont_prod[i] != 1 )
      {  cout << "error: valor " << i << " producido " << cont_prod[i] << " veces." << endl ;
         ok = false ;
      }
      if ( cont_cons[i] != 1 )
      {  cout << "error: valor " << i << " consumido " << cont_cons[i] << " veces" << endl ;
         ok = false ;
      }
   }
   if (ok)
      cout << endl << flush << "solución (aparentemente) correcta." << endl << flush ;
}

//----------------------------------------------------------------------

void  funcion_hebra_productora( int i )
{
for (unsigned j = i*p ; j<i*p +p; j++ )
   {
      int dato = producir_dato(i) ;
	  sem_wait(puede_escribir);{
			sem_wait(cambiaindice);
			buffer[primera_libre] = dato;
			primera_libre =(primera_libre+1) %tam_vec;
			sem_signal(cambiaindice);
		}
		sem_signal(puede_leer);
   }
}

//----------------------------------------------------------------------

void funcion_hebra_consumidora( int i )
{
   for( unsigned i = 0 ; i < num_items/HEBRASCONSUMIDORAS ; i++ )
   {
	sem_wait(puede_leer);{
			sem_wait(cambiaindice1);
	        consumir_dato(buffer[primera_ocupada],i);
			primera_ocupada = (primera_ocupada +1)%tam_vec;
			sem_signal(cambiaindice1);
		}
		sem_signal(puede_escribir);
    }
}
//----------------------------------------------------------------------

int main()
{
	thread consumidoras[HEBRASCONSUMIDORAS];
	thread productoras[HEBRASPRODUCTORAS];
   cout << "-----------------------------------------------------------------" << endl
        << "Problema de los productores-consumidores (solución FIFO)." << endl
        << "------------------------------------------------------------------" << endl
        << flush ;

   for (int i= 0; i< HEBRASPRODUCTORAS; i++) {
	productoras[i]=thread(funcion_hebra_productora,i);
   } 
	for (int i= 0; i< HEBRASCONSUMIDORAS; i++) {
		consumidoras[i]=thread(funcion_hebra_consumidora,i);
   }
   for (int i= 0; i< HEBRASPRODUCTORAS; i++) {
	productoras[i].join();
   } 
	for (int i= 0; i< HEBRASCONSUMIDORAS; i++) {
		consumidoras[i].join();
   }


   test_contadores();
}
