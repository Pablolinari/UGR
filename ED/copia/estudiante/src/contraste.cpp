/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/cppFiles/file.cc to edit this template
 */


#include <iostream>
#include <cmath>
#include <image.h>
#include <cassert>


using namespace std;

/*
 * 
 */
int main(int argc, char ** argv) {
    if (argc != 7){
        cout << "Argumentos no son corectos. ";
    }
    else{
        Image img;
        
        img.Load(*(argv+1));
        img.AdjustContrast( atoi(argv[3]) , atoi(argv[4]) , atoi(argv[5]),atoi(argv[6]) );
        img.Save(*(argv+2));
    }
    return 0;
}


