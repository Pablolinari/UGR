/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/cppFiles/main.cc to edit this template
 */

/* 
 * File:   icono.cpp
 * Author: pablolinari
 *
 * Created on 15 de octubre de 2023, 21:16
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
    if (argc != 4 ){
        cout << "Argumentos no son corectos. ";
    }
    else{
        Image img;
        
        img.Load(*(argv+1));
        Image subsample(img.Subsample(*(*(argv+3))));
        subsample.Save(*(argv+2));
    }
    return 0;
}

