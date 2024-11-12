#include <functional>
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
   max_ms    = 20 ; 

class lectorescritor : public HoareMonitor{
private:
	bool escrib;
	int n_lec ;

	CondVar lectura, escritura;

	// constantes ('static' 
public:
	void ini_lectura(int i);
	void fin_lectura(int i);
	void ini_escritura(int i);
	void fin_escritura(int i);
	lectorescritor();
};

lectorescritor::lectorescritor(){
	n_lec = 0;
	escrib=false;
	lectura = newCondVar();
	escritura = newCondVar();
}
void lectorescritor::ini_lectura(int i){
	if(escrib){
		lectura.wait();
	}
		cout<<"Hebra "<<i<<" empieza a leer"<<endl;
	n_lec++;
	lectura.signal();
}

void lectorescritor::fin_lectura(int i){
	cout<<"Hebra "<<i<<"  termina de leer"<<endl;
	n_lec--;
	if(n_lec ==0){
		escritura.signal();
	}
}

void lectorescritor::ini_escritura(int i){
	if(n_lec>0 || !escrib){
		escritura.wait();
	}
	cout<<"Hebra "<<i<<" empieza a escribir"<<endl;
	escrib=true;
}
void lectorescritor::fin_escritura(int i){
	cout<<"Hebra "<<i<<" termina de escribir"<<endl;
	escrib=false;
	if(!lectura.empty()){
		lectura.signal();
	}else{
		escritura.signal();
	}
}
void lector(MRef<lectorescritor>monitor,int i){
	while(true){
		monitor->ini_lectura(i);
   		this_thread::sleep_for( chrono::milliseconds( aleatorio<min_ms,max_ms>() ));
		monitor->fin_lectura(i);
   this_thread::sleep_for( chrono::milliseconds( aleatorio<min_ms,max_ms>() ));
	}

}void  escritor(MRef<lectorescritor>monitor,int i){
	while(true){
		monitor->ini_escritura(i);
   this_thread::sleep_for( chrono::milliseconds( aleatorio<min_ms,max_ms>() ));

		monitor->fin_escritura(i);
   this_thread::sleep_for( chrono::milliseconds( aleatorio<min_ms,max_ms>() ));
	}

}
int main (int argc, char *argv[]) {
	int numlec=4,numesc=4;
	thread lectoras[numlec],escritoras[numesc];
	
   MRef<lectorescritor> monitor = Create<lectorescritor>() ;	
	for(int i = 0; i< numesc; i++){
		escritoras[i]=thread(escritor,monitor,i);
	}	

	for(int i = 0; i< numlec; i++){
		lectoras[i]=thread(lector,monitor,i);
	}
	for(int i = 0; i< numlec; i++){
		lectoras[i].join();
	}
	for(int i = 0; i< numesc; i++){
		escritoras[i].join();
	}

	return 0;
}
