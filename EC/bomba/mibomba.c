// gcc -Og bomba.c -o bomba -no-pie -fno-guess-branch-probability
#include <stdio.h>    // para printf(), fgets(), scanf()
#include <stdlib.h>   // para exit()
#include <string.h>   // para strncmp()
#include <sys/time.h> // para gettimeofday(), struct timeval
#define SIZE 100
#define TLIM 5
char password[] = ""; // contraseña
int base[]={132,111,327,98,388,69,335,116,690,122};
int a =10;
int passcode = 34567;    // pin
void boom(void)
{
    printf("\n"
           "***************\n"
           "*** BOOM!!! ***\n"
           "***************\n"
           "\n");
    exit(-1);
}
void defused(void)
{
    printf("\n"
           "·························\n"
           "··· bomba desactivada ···\n"
           "·························\n"
           "\n");
    exit(0);
}


int main()
{
    char pw[SIZE];
    int pc, n;
    struct timeval tv1, tv2; // gettimeofday() secs-usecs
    gettimeofday(&tv1, NULL);
    do
        printf("\nIntroduce la contraseña: ");
    while (fgets(pw, SIZE, stdin) == NULL);
    int conv[10];
    int s = strlen(pw)-1;
    int div = 2;
    if(s != a){
        boom();
    }
    for(int i = 0 ; i< a; i++){
        if(i%2 != 0){
            conv[i] = div*pw[i]; 
        }
        else{
            conv[i] = pw[i];
        }
        if((i+1)%2 ==0){
           div++;
        }

    }

    for(int i = 0; i!= a; ++i){
        if(conv[i] != base[i]){
            boom();
        }
        
    }

    
   
    do
    {
        printf("\nIntroduce el pin: ");
        if ((n = scanf("%i", &pc)) == 0)
            scanf("%*s") == 1;
    } while (n != 1);
    
    gettimeofday(&tv1, NULL);
    if (tv1.tv_sec - tv2.tv_sec > TLIM)
        boom();
    defused();
}