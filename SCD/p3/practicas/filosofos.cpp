// -----------------------------------------------------------------------------
//
// Sistemas concurrentes y Distribuidos.
// Práctica 3. Implementación de algoritmos distribuidos con MPI
//
// Archivo: filosofos-plantilla.cpp
// Implementación del problema de los filósofos (sin camarero).
// Plantilla para completar.
//
// Historial:
// Actualizado a C++11 en Septiembre de 2017
// -----------------------------------------------------------------------------


// Funciones MPI
// MPI_Send(*buf, int count, MPI_Datatype datatype, int dest, int tag, MPI_Comm comm) -> envio asincrono seguro
// MPI_Recv(void *buf, int count, MPI_Datatype datatype, int source, int tag, MPI_Comm comm, MPI_Status *status) -> espera a recibir el mensaje
// MPI_Ssend(*buf, int count, MPI_Datatype datatype, int dest, int tag, MPI_Comm comm) -> Envio sincrono seguro 
// MPI_Iprobe(int source, int tag, MPI_Comm comm, int *flag, MPI_Status *status) -> consultar si hay o no un mensaje pendiente
// MPI_Probe(int source, int tag, MPI_Comm comm, MPI_Status *status) -> espera bloqueado hasta que haya un mensaje pendiente
// MPI_Get_count(MPI_Status *status, MPI_Datatype datatype, int *count) -> Obtiene el numero de valores recibidos. Se suele usar en conjuncion de Probe o Iprobe
// MPI_Isend(*buf, int count, MPI_Datatype datatype, int dest, int tag, MPI_Comm comm, MPI_Request *request) -> Inicia envio pero retorna antes de leer el buffer
// MPI_Irecv(*buf, int count, MPI_Datatype datatype, int source, int tag, MPI_Comm comm, MPI_Request *request) -> Recibe mensaje pero no queda bloqueado. Para saber acerca del mensaje si se ha recibido o no se utilizan las siguiente funciones
// MPI_Wait(MPI_Request *request, MPI_Status *status) -> Queda bloqueado hasta que se termine el envio o recepcion
// MPI_Test(MPI_Request *request, int *flag, MPI_Status *status) -> Ve si el envio o recepcion han terminado. No bloqueante
//
// Miscelaneo: MPI_ANY_SOURCE, MPI_ANY_TAG se utilizan en las recepciones de mensajes para indicar que puede ser desde cualquier
// source o tag respectivamente.
// Estructuras:
	// MPI_Status status: status.MPI_SOURCE y status.MPI_TAG
	// MPI_Request: sirve solamente para pasarlo a las funciones Wait y Test para ver el estado del envio o recepcion
// En general cuando flag > 0 significa que se ha completado lo que ha consultado la funcion.


// Para compilar y ejecutar y fichero ejemplo.cpp:
	// mpicxx -std=c++11 -o ejemplo ejemplo.cpp
	// mpirun -oversubscribe -np 4 ./ejemplo


#include <mpi.h>
#include <thread> // this_thread::sleep_for
#include <random> // dispositivos, generadores y distribuciones aleatorias
#include <chrono> // duraciones (duration), unidades de tiempo
#include <iostream>

using namespace std;
using namespace std::this_thread ;
using namespace std::chrono ;

const int
   num_filosofos = 5 ,              // número de filósofos 
   num_filo_ten  = 2*num_filosofos, // número de filósofos y tenedores 
   num_procesos  = num_filo_ten ;   // número de procesos total (por ahora solo hay filo y ten)


//**********************************************************************
// plantilla de función para generar un entero aleatorio uniformemente
// distribuido entre dos valores enteros, ambos incluidos
// (ambos tienen que ser dos constantes, conocidas en tiempo de compilación)
//----------------------------------------------------------------------

template< int min, int max > int aleatorio()
{
  static default_random_engine generador( (random_device())() );
  static uniform_int_distribution<int> distribucion_uniforme( min, max ) ;
  return distribucion_uniforme( generador );
}

// ---------------------------------------------------------------------

void funcion_filosofos( int id ){
  int id_ten_izq = (id+1)              % num_filo_ten, //id. tenedor izq.
      id_ten_der = (id+num_filo_ten-1) % num_filo_ten; //id. tenedor der.
	int msg=id; 

  while ( true ){
		if (id ==0){
    cout <<"Filósofo " <<id << " solicita ten. izq." <<id_ten_der<<endl;
    
		MPI_Ssend(&msg,1,MPI_INT,id_ten_der,0,MPI_COMM_WORLD);

    cout <<"Filósofo " <<id <<" solicita ten. der." <<id_ten_izq <<endl;
		
		MPI_Ssend(&msg,1,MPI_INT,id_ten_izq,0,MPI_COMM_WORLD);
		}
		cout <<"Filósofo " <<id << " solicita ten. izq." <<id_ten_izq <<endl;
    
		MPI_Ssend(&msg,1,MPI_INT,id_ten_izq,0,MPI_COMM_WORLD);

    cout <<"Filósofo " <<id <<" solicita ten. der." <<id_ten_der <<endl;
		
		MPI_Ssend(&msg,1,MPI_INT,id_ten_der,0,MPI_COMM_WORLD);

    cout <<"Filósofo " <<id <<" comienza a comer" <<endl ;
    sleep_for( milliseconds( aleatorio<10,100>() ) );

    cout <<"Filósofo " <<id <<" suelta ten. izq. " <<id_ten_izq <<endl;
    // ... soltar el tenedor izquierdo (completar)
		MPI_Ssend(&msg,1,MPI_INT,id_ten_izq,0,MPI_COMM_WORLD);


    cout<< "Filósofo " <<id <<" suelta ten. der. " <<id_ten_der <<endl;
    // ... soltar el tenedor derecho (completar)
		MPI_Ssend(&msg,1,MPI_INT,id_ten_der,0,MPI_COMM_WORLD);


    cout << "Filosofo " << id << " comienza a pensar" << endl;
    sleep_for( milliseconds( aleatorio<10,100>() ) );
 }
}
// ---------------------------------------------------------------------

void funcion_tenedores( int id ){
  int valor, id_filosofo ;  // valor recibido, identificador del filósofo
  MPI_Status estado ;       // metadatos de las dos recepciones

  while ( true ){
     // ...... recibir petición de cualquier filósofo (completar)
		MPI_Recv(&id_filosofo,1, MPI_INT ,MPI_ANY_SOURCE, 0, MPI_COMM_WORLD, &estado);
     // ...... guardar en 'id_filosofo' el id. del emisor (completar)
     cout <<"Ten. " <<id <<" ha sido cogido por filo. " <<id_filosofo <<endl;

     // ...... recibir liberación de filósofo 'id_filosofo' (completar)

		MPI_Recv(&valor,1, MPI_INT ,id_filosofo, 0, MPI_COMM_WORLD, &estado);
			
     cout <<"Ten. "<< id<< " ha sido liberado por filo. " <<id_filosofo <<endl ;
  }
}
// ---------------------------------------------------------------------

int main( int argc, char** argv )
{
   int id_propio, num_procesos_actual ;

   MPI_Init( &argc, &argv );
   MPI_Comm_rank( MPI_COMM_WORLD, &id_propio );
   MPI_Comm_size( MPI_COMM_WORLD, &num_procesos_actual );


   if ( num_procesos == num_procesos_actual )
   {
      // ejecutar la función correspondiente a 'id_propio'
      if ( id_propio % 2 == 0 )          // si es par
         funcion_filosofos( id_propio ); //   es un filósofo
      else                               // si es impar
         funcion_tenedores( id_propio ); //   es un tenedor
   }
   else
   {
      if ( id_propio == 0 ) // solo el primero escribe error, indep. del rol
      { cout << "el número de procesos esperados es:    " << num_procesos << endl
             << "el número de procesos en ejecución es: " << num_procesos_actual << endl
             << "(programa abortado)" << endl ;
      }
   }

   MPI_Finalize( );
   return 0;
}

// ---------------------------------------------------------------------
