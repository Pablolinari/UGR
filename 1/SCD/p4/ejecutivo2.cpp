// -----------------------------------------------------------------------------
//
// Sistemas concurrentes y Distribuidos.
// Práctica 4. Implementación de sistemas de tiempo real.
//
// Archivo: ejecutivo1.cpp
// Implementación del primer ejemplo de ejecutivo cíclico:
//
//   Datos de las tareas:
//   ------------
//   Ta.  T    C
//   ------------
//   A  250  100
//   B  250   80
//   C  500   50
//   D  500   40
//   E 1000   20
//  -------------
//
//  Planificación (con Ts == 250 ms)
//  *---------*----------*---------*--------*
//  | A B C   | A B D E  | A B C   | A B D  |
//  *---------*----------*---------*--------*
//
//
// Historial:
// Creado en Diciembre de 2017
// -----------------------------------------------------------------------------

#include <chrono>   // utilidades de tiempo
#include <iostream> // cout, cerr
#include <ratio>    // std::ratio_divide
#include <string>
#include <thread>

using namespace std;
using namespace std::chrono;
using namespace std::this_thread;

// tipo para duraciones en segundos y milisegundos, en coma flotante:
// typedef duration<float,ratio<1,1>>    seconds_f ;
typedef duration<float, ratio<1, 1000>> milliseconds_f;

// -----------------------------------------------------------------------------
// tarea genérica: duerme durante un intervalo de tiempo (de determinada
// duración)

void Tarea(const std::string &nombre, milliseconds tcomputo) {
  cout << "   Comienza tarea " << nombre << " (C == " << tcomputo.count()
       << " ms.) ... ";
  sleep_for(tcomputo);
  cout << "fin." << endl;
}

// -----------------------------------------------------------------------------
// tareas concretas del problema:

void TareaA() { Tarea("A", milliseconds(100)); }
void TareaB() { Tarea("B", milliseconds(120)); }
void TareaC() { Tarea("C", milliseconds(40)); }
void TareaD() { Tarea("D", milliseconds(30)); }

// -----------------------------------------------------------------------------
// implementación del ejecutivo cíclico:

int main(int argc, char *argv[]) {
  // Ts = duración del ciclo secundario (en unidades de milisegundos, enteros)
  const milliseconds Ts_ms(200);

  // ini_sec = instante de inicio de la iteración actual del ciclo secundario
  time_point<steady_clock> ini_sec = steady_clock::now();

  while (true) // ciclo principal
  {
    cout << endl
         << "---------------------------------------" << endl
         << "Comienza iteración del ciclo principal." << endl;

    for (int i = 1; i <= 4; i++) // ciclo secundario (4 iteraciones)
    {
      cout << endl
           << "Comienza iteración " << i << " del ciclo secundario." << endl;

      switch (i) {
      case 1:
        TareaD();
        TareaC();
        TareaB();
        break;
      case 2:
        TareaD();
        TareaC();
        TareaA();
        break;
      case 3:
        TareaD();
        TareaC();
        break;
      case 4:
        TareaD();
        TareaC();
        TareaA();
        break;
      }

      // calcular el siguiente instante de inicio del ciclo secundario
      ini_sec += Ts_ms;

      // esperar hasta el inicio de la siguiente iteración del ciclo secundario
      sleep_until(ini_sec);

      float retraso = milliseconds_f(steady_clock::now() - ini_sec).count();
      cout << "Retraso = " << retraso << " milisegundos." << endl;
    }
  }
}

// PREGUNTA 1
//  El tiempo de espera mas corto en este caso se da
//  en el primer ciclo secundario siendo este de 10 ms
//
//  PREGUNTA 2
//  Si sique siendo planificable si D es 40 ya que el
//  tiempo de espera mas corto que se da es de 10ms por
//  sigue cabiendo la tarea aunque se aumente en 10 segundos
