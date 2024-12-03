#include <mpi.h>
#include <iostream>
#include <ostream>

using namespace std;
static int contador =0;
int main (int argc, char *argv[]) {
	int id;
	MPI_Init(&argc,&argv);

	MPI_Comm_rank(MPI_COMM_WORLD, &id);
	if (id==0) {
		contador=1;
		cout<<"proceso "<<id <<" "<<contador<<endl<<flush;
	
	}
	else {
		
		cout<<"proceso "<<id <<" "<<contador<<endl<<flush;
	}
	MPI_Finalize();
	return 0;
}
