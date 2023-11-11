//tarea4.c
//Trabajo con llamadas al sistema del Subsistema de Procesos "POSIX 2.10 compliant"
//Prueba el programa tal y como está. Después, elimina los comentarios (1) y pruebalo de nuevo.

#include<sys/types.h>	//Primitive system data types for abstraction of implementation-dependent data types.
						//POSIX Standard: 2.6 Primitive System Data Types <sys/types.h>
#include<unistd.h>		//POSIX Standard: 2.10 Symbolic Constants         <unistd.h>
#include<stdio.h>
#include<errno.h>
#include <stdlib.h>
#include <string.h>

int global=6;
char buf[]="cualquier mensaje de salida\n";

int main(int argc, char *argv[])
{
int var;
pid_t pid;
char * copiargv[5];

var=88;
if(write(STDOUT_FILENO,buf,sizeof(buf)+1) != sizeof(buf)+1) {
	perror("\nError en write");
	exit(EXIT_FAILURE);
}
//(1)if(setvbuf(stdout,NULL,_IONBF,0)) {
//	perror("\nError en setvbuf");
//}
printf("\nMensaje previo a la ejecución de fork");

if( (pid=fork())<0) {
	perror("\nError en el fork");
	exit(EXIT_FAILURE);
}

for(int i = 0; i<4; i++){
	copiargv[i] = argv[i];
}
copiargv[4] = NULL;

if(pid==0) {  
	if(strcmp((argv[argc-1]), "bg")) {

		execvp(argv[1] , copiargv);
	}
	else{
		
	}
}

}

