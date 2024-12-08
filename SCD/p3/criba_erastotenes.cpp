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
	num=-1;
	MPI_Send(&num,1, MPI_INT,1,0, MPI_COMM_WORLD);

}

void procesofilter(int id , int next_id){
	int valor,primo;
 	MPI_Status estado;
	bool continua =true;
	MPI_Recv(&primo,1, MPI_INT , id-1 ,0, MPI_COMM_WORLD, &estado);
	MPI_Send(&primo,1, MPI_INT,idprinter,0, MPI_COMM_WORLD);

	while (continua) {
		MPI_Recv(&valor,1, MPI_INT , id-1 ,0, MPI_COMM_WORLD, &estado);
		if(valor%primo!=0){
			MPI_Send(&valor,1, MPI_INT,next_id,0, MPI_COMM_WORLD);
		}
		if(valor == -1){
			continua = false;
		}
	}
}

void procesofinal(int id){
	int primo;
	MPI_Status estado;
	bool continua = true;
	MPI_Recv(&primo,1, MPI_INT ,id-1,0, MPI_COMM_WORLD, &estado);
	while (continua) {
		MPI_Recv(&primo,1, MPI_INT ,id-1,0, MPI_COMM_WORLD, &estado);
		if(primo == -1){continua=false;}
	}

}

void procesoprinter(){
	bool continua = true;
	MPI_Status estado;
	int primo ;
	while (continua) {
		MPI_Recv(&primo,1, MPI_INT,MPI_ANY_SOURCE,0, MPI_COMM_WORLD, &estado);
		if(primo == -1){
			continua = false;
		}
	}
}

int main (int argc, char *argv[]) {
	MPI_Init(&argc,&argv);
	int id_propio , num_procesos_actual;
  MPI_Comm_rank( MPI_COMM_WORLD, &id_propio );
  MPI_Comm_size( MPI_COMM_WORLD, &num_procesos_actual );
	
	if (id_propio == 0) {
		procesostart();
	}
	else if(id_propio == nlimit-1){
		procesoprinter();
	}
	else if (id_propio == nlimit-2) {
		procesofinal(id_propio);
	}
	else{
		procesofilter(id_propio,id_propio +1);
	}


	MPI_Finalize();
	return 0;
}

