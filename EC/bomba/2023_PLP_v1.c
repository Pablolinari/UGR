// gcc -Og 2023_PLP_v1.c -o 2023_PLP_v1 -no-pie -fno-guess-branch-probability
#include <stdio.h>    // para printf(), fgets(), scanf()
#include <stdlib.h>   // para exit()
#include <string.h>   // para strncmp()
#include <sys/time.h> // para gettimeofday(), struct timeval
#define SIZE 100
#define TLIM 20

char password[] = ""; // contraseña
int base[]={132,111,327,98,388,69,335,116,690,122}; // Contraseña a introducir  = BombaECtsz
int a =6;
char cont [] = "wzCbdupxFAtsoOP\0" ;   //x69 // pin    499485
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
    int pc,pp = 0, n;
    struct timeval tv1, tv2; // gettimeofday() secs-usecs
    gettimeofday(&tv1, NULL);
    do
        printf("\nIntroduce la contraseña: ");
    while (fgets(pw, SIZE, stdin) == NULL);
    int conv[10];
    int s = strlen(pw)-1;
    int div = 2;
    
    gettimeofday(&tv1, NULL);
    if (  tv2.tv_sec-tv1.tv_sec > TLIM){
        boom();
    }
    
    if(s != a+4){
        boom();
    }
    for(int i = 0 ; i< a+4; i++){
        if(i%2 == 0){
            conv[i] = div*pw[i]; 
        }
        else{
            conv[i] = pw[i];
        }
        if((i+1)%2 ==0){
           div++;
        }

    }

    for(int i = 0; i!= a+4; ++i){
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


    for(int i = 0 ; i<a+9 ; i++){
        pp+=cont[i];
    }
    pp = base[6]*pp;
    
    if (pc != pp  ){
        boom();
    }
    gettimeofday(&tv1, NULL);
    if (  tv2.tv_sec-tv1.tv_sec > TLIM){
        boom();
    }
    defused();

    return 0;
}