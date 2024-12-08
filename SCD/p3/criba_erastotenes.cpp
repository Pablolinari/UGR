#include <mpi.h>
#include <iostream>
using namespace std;

const int nlimit = 35;
const int idprinter=0;

void procesostart(){
	int num = 2;
	MPI_Send(&num, 1,MPI_INT,idprinter,0, MPI_COMM_WORLD);
		cout<<"start imprime"<<endl;
	for (int i = 3;i<nlimit; i+=2) {
		cout<<"start manda "<< i<<endl;
		num = i;
		MPI_Send(&num,1, MPI_INT,2,0, MPI_COMM_WORLD);
	}
	num=-1;
	MPI_Send(&num,1, MPI_INT,2,0, MPI_COMM_WORLD);
	cout<<"start termina"<< endl;

}

void procesofilter(int id ){
	int valor,primo;
 	MPI_Status estado;
	bool continua =true;
	MPI_Recv(&primo,1, MPI_INT , id-1 ,0, MPI_COMM_WORLD, &estado);
	MPI_Send(&primo,1, MPI_INT,idprinter,0, MPI_COMM_WORLD);

	while (continua) {
		MPI_Recv(&valor,1, MPI_INT , id-1 ,0, MPI_COMM_WORLD, &estado);
		cout<<"proceso  "<< id<<" recibe "<<valor<<endl;
		if(valor%primo!=0){
			MPI_Send(&valor,1, MPI_INT,id+1,0, MPI_COMM_WORLD);
		}
		if(valor == -1){
			continua = false;
		}
	}
	cout << "proceso con id termina "<<id<< endl;
}

void procesofinal(int id){
	int primo;

	MPI_Status estado;
	bool continua = true;
	MPI_Recv(&primo,1, MPI_INT ,id-1,0, MPI_COMM_WORLD, &estado);
	MPI_Send(&primo,1, MPI_INT,idprinter,0, MPI_COMM_WORLD);
		cout<<"proceso final "<<endl;
	while (continua) {
		MPI_Recv(&primo,1, MPI_INT ,id-1,0, MPI_COMM_WORLD, &estado);
		cout<<"proceso final recibe "<<primo<<endl;
		if(primo == -1){
			continua=false;
			MPI_Send(&primo,1, MPI_INT,idprinter,0, MPI_COMM_WORLD);
		}	
	}
	cout << "proceso final termina "<< endl;

}

void procesoprinter(){
	bool continua = true;
	MPI_Status estado;
	int primo ;
	while (continua){		
		
		MPI_Recv(&primo,1, MPI_INT,MPI_ANY_SOURCE,0, MPI_COMM_WORLD, &estado);
		
		if(primo == -1){
			continua = false;
		}else{
			cout <<"NUMERO PRIMO "<< primo<<" ENCONTRADO POR "<<estado.MPI_SOURCE<<endl;
		}
	}
	cout << "proceso printer termina "<< endl;
	
}

int main (int argc, char *argv[]) {
	MPI_Init(&argc,&argv);
	int id_propio , num_procesos_actual;
  MPI_Comm_rank( MPI_COMM_WORLD, &id_propio );
  MPI_Comm_size( MPI_COMM_WORLD, &num_procesos_actual );

	if (id_propio == 1) {
		procesostart();
	}
	else if(id_propio ==0){
		procesoprinter();
	}
	else if (id_propio == num_procesos_actual-1) {
		procesofinal(id_propio);
	}
	else{
		procesofilter(id_propio);
	}
	MPI_Finalize();
	return 0;
}

