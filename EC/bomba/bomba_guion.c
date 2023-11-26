// gcc -Og bomba.c -o bomba -no-pie -fno-guess-branch-probability
#include <stdio.h>    // para printf(), fgets(), scanf()
#include <stdlib.h>   // para exit()
#include <string.h>   // para strncmp()
#include <sys/time.h> // para gettimeofday(), struct timeval
#define SIZE 100
#define TLIM 5
char password[] = "\n"; // contraseña
int passcode = 7777;               // pin
void boom(void) {
  printf("\n"
         "***************\n"
         "*** BOOM!!! ***\n"
         "***************\n"
         "\n");
  exit(-1);
}
void defused(void) {
  printf("\n"
         "·························\n"
         "··· bomba desactivada ···\n"
         "·························\n"
         "\n");
  exit(0);
}
int encrip1(char * cad1 , char * cad2){
  for(int i = 0; i < strlen(cad1); i++){

  }
}

int main() {


  return 0;
}
