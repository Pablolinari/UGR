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
int primera_ocupada =0,primera_libre = 0;
int producidos[HEBRASPRODUCTORAS]={0};
int p = num_items/HEBRASPRODUCTORAS;

//**********************************************************************
// funciones comunes a las dos soluciones (fifo y lifo)
//----------------------------------------------------------------------

unsigned producir_dato(int i)
{

   this_thread::sleep_for( chrono::milliseconds( aleatorio<20,100>() ));
	int dato_producido = i*p + producidos[i];
   producidos[i]+=1

   cout << "producido: " << dato_producido << endl << flush ;
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
for (unsigned j = 0 ; j < num_items/HEBRASPRODUCTORAS ; j++ )
   {
      int dato = producir_dato(i) ;
	  sem_wait(puede_escribir);{
			buffer[primera_libre] = dato;
			primera_libre =(primera_libre+1) %tam_vec;
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
	        consumir_dato(buffer[primera_ocupada],i);
			primera_ocupada = (primera_ocupada +1)%tam_vec;

			
		}
		sem_signal(puede_escribir);
    }
}
//----------------------------------------------------------------------

int main()
{
   cout << "-----------------------------------------------------------------" << endl
        << "Problema de los productores-consumidores (solución LIFO o FIFO ?)." << endl
        << "------------------------------------------------------------------" << endl
        << flush ;

   thread hebra_productora ( funcion_hebra_productora ),
          hebra_consumidora1( funcion_hebra_consumidora ),hebra_consumidora2(funcion_hebra_consumidora);

   hebra_productora.join() ;
   hebra_consumidora.join() ;

   test_contadores();
}
