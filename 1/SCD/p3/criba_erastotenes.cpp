
//-----------------------------------------------------------------
//Pablo Linari Perez criba de Erastotenes 
//-----------------------------------------------------------------

#include <mpi.h>
#include <iostream>
using namespace std;

const int nlimit = 100;
const int idprinter=0; 

void procesostart(){
	int num = 2;
	//enviar el numero 2 al proceso printer
	MPI_Send(&num, 1,MPI_INT,idprinter,0, MPI_COMM_WORLD); 
	//producir los demas numeros impares 
	for (int i = 3;i<nlimit; i+=2) {
		//cout<<"start manda "<< i<<endl;
		num = i;
		//enviar el siguiente numero al primer filter 
		MPI_Send(&num,1, MPI_INT,2,0, MPI_COMM_WORLD);
	}
	num=-1;
	//indicar al filter que se ha terminado la produccion de numeros
	MPI_Send(&num,1, MPI_INT,2,0, MPI_COMM_WORLD);

}

void procesofilter(int id ){
	int valor,primo;
 	MPI_Status estado;
	bool continua =true;
	//Recibir el primo y mandarlo a imprimir 
	MPI_Recv(&primo,1, MPI_INT , id-1 ,0, MPI_COMM_WORLD, &estado);
	MPI_Send(&primo,1, MPI_INT,idprinter,0, MPI_COMM_WORLD);
	//comprobar que no se haya terminado la produccion de numeros 
	if(primo ==-1){
		continua=false;
		//Mandar la senial de terminar al siguiente proceso
		MPI_Send(&primo,1, MPI_INT,id+1,0, MPI_COMM_WORLD);
	}
	
	while (continua) {
		MPI_Recv(&valor,1, MPI_INT , id-1 ,0, MPI_COMM_WORLD, &estado);
		//El valor recibido se manda al siguiente proceso si no es divisible por el primo 
		if(valor%primo!=0){
			MPI_Send(&valor,1, MPI_INT,id+1,0, MPI_COMM_WORLD);
		}
		//terminar la ejecucion del proceso si no hay mas numeros 
		if(valor == -1){
			//se comunica a los procesos restantes por si estos no han participado en la busqueda 
			MPI_Send(&valor,1, MPI_INT,id+1,0, MPI_COMM_WORLD);
			continua = false;
		}
	}
}

void procesofinal(int id){
	int primo;
	MPI_Status estado;
	bool continua = true;
	//Recibe y manda a imprimir el ultimo primo 
	MPI_Recv(&primo,1, MPI_INT ,id-1,0, MPI_COMM_WORLD, &estado);
	MPI_Send(&primo,1, MPI_INT,idprinter,0, MPI_COMM_WORLD);
	if(primo ==-1 ){continua=false;}
	while (continua) {
		//descarta los demas numeros 
		MPI_Recv(&primo,1, MPI_INT ,id-1,0, MPI_COMM_WORLD, &estado);
		if(primo == -1){
			continua=false;
		}	
	}

}

void procesoprinter(int tope){
	bool continua =true;
	int cont=0;
	MPI_Status estado;
	int primo ;
	//recibe los primos y los imprime si no se ha llegado al tope o se ha llegado al ultimo numero 
	while (continua&& cont <tope){		
		
		MPI_Recv(&primo,1, MPI_INT,MPI_ANY_SOURCE,0, MPI_COMM_WORLD, &estado);
		if (primo ==-1) {
			continua =false;
		}else{

		cout <<"NUMERO PRIMO "<< primo<<" ENCONTRADO POR "<<estado.MPI_SOURCE<<endl;
		}
		cont++;
	}
	
}

int main (int argc, char *argv[]) {
	MPI_Init(&argc,&argv);
	int id_propio , num_procesos_actual;
  MPI_Comm_rank( MPI_COMM_WORLD, &id_propio );
  MPI_Comm_size( MPI_COMM_WORLD, &num_procesos_actual );
	//proceso start con id 1
	if (id_propio == 1) {
		procesostart();
	}
	//proceso printer con id 0
	else if(id_propio ==0){
		procesoprinter(num_procesos_actual-1);
	}
	//proceso final con id numprocesos -1
	else if (id_propio == num_procesos_actual-1) {
		procesofinal(id_propio);
	}
	else{
		procesofilter(id_propio);
	}
	MPI_Finalize();
	return 0;
}

