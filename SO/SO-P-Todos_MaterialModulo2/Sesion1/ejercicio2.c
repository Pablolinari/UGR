#include<unistd.h>
#include<stdio.h>
#include<stdlib.h>
#include<sys/types.h>
#include<sys/stat.h>
#include<fcntl.h>
#include<errno.h>

int main(int argcc , char*argv[]){
   int fde , fds;

   if(fde=open(argv[1],O_RDONLY) < 0){
	printf("\nError %d en open",errno);
	perror("\nError en open");
	exit(EXIT_FAILURE);

   }
   if( (fds=open("salida.txt",O_WRONLY))<0) {
	printf("\nError %d en open",errno);
	perror("\nError en open");
	exit(EXIT_FAILURE);
}
    char buffer[80];
    char cadena[80];
    int leidos = 0;
    
    while(read(fde,buffer,80*sizeof(char)) != 0){
        sprintf(cadena,"bloque %d/n", leidos);
        write(fds,buffer,leidos * sizeof(char));
           
    }

    return EXIT_SUCCESS;
}