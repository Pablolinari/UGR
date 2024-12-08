#include <mpi.h>
#include <iostream>

using namespace std;

const int nlimit = 10;
const int idstart = 0;
const int idprinter=nlimit-1;

void procesostart(){
	int num = 2;
	MPI_Send(&num, 1,MPI_INT,idprinter,0, MPI_COMM_WORLD);
	for (int i = 3;i<nlimit; i+=2) {
		num = i;
		MPI_Send(&num,1, MPI_INT,1,0, MPI_COMM_WORLD);
	}

}

void procesofilter(int id , int next_id){
	
}

void procesofilter(int id){

}

int main (int argc, char *argv[]) {
	MPI_Init(&argc,&argv);
	


	MPI_Finalize();
	return 0;
}

