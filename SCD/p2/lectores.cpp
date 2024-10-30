#include <iostream>
#include <iomanip>
#include <cassert>
#include <random>
#include <thread>
#include "scd.h"

using namespace std ;
using namespace scd ;

class lectorescritor : public HoareMonitor{
private:
	bool escrib = true ;
	int n_lec = 0;

	CondVar lectura, escritura;

	// constantes ('static' 
	void ini_lectura();
	void fin_lectura();
	void ini_escritura();
	void fin_escritura();
	lectorescritor();
};

lectorescritor::lectorescritor(){
	n_lec = 0;
	escrib=true;
}
void lectorescritor::ini_lectura(){
	if(escrib){
		lectura.wait();
	}
	n_lec++;
	lectura.signal();
}

void lectorescritor::fin_lectura(){
	n_lec--;
	if(n_lec ==0){
		escritura.signal();
	}
}

void lectorescritor::ini_escritura(){
	if(n_lec>0 || escrib){
		escritura.wait();
	}
	escrib=true;
}
void lectorescritor::fin_escritura(){
	escrib=false;
	if(!lectura.empty()){
		lectura.signal();
	}else{
		escritura.signal();
	}
}
int main (int argc, char *argv[]) {
	int numlec=4,numesc=4;
	thread lectoras[numlec],escritoras[numesc];
	return 0;
}
