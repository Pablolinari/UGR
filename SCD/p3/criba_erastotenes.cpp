#include <mpi.h>
#include <iostream>

using namespace std; 
const int nlimite =14;
const int id_printer=1;
const int id_first = 2;
const int etiq_filter = 1;
const int id_start = 0;
void procesostart(){
	int primervalor = 2,segundovalor = 3;
  MPI_Ssend( &primervalor, 1, MPI_INT, id_printer, 0, MPI_COMM_WORLD );
  for (int i =3;i< nlimite;i+=2) {
		segundovalor=i;
		MPI_Ssend( &segundovalor, 1, MPI_INT, id_first, etiq_filter, MPI_COMM_WORLD );
  }
}

void procesoprinter(){
	int num;
	MPI_Status estado;
	MPI_Recv(&num,1, MPI_INT, MPI_ANY_SOURCE,0,MPI_COMM_WORLD ,&estado );
	cout<< "Se ha recibido el numero :"<<num<<endl<<flush;
}
void procesofilter(){
	

}
void procesofinal(){

}
int main (int argc, char *argv[]) {
	MPI_Init(&argc,&argv);
	MPI_Finalize();
	
	return 0;
}
