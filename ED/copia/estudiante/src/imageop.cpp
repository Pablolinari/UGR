/**
 * @file imageop.cpp
 * @brief Fichero con definiciones para el resto de métodos de la clase Image
 */

#include <iostream>
#include <cmath>
#include <image.h>
#include <cassert>

 Image Image::Zoom2X() const{
     int ncolszoom=2*get_cols()-1;
     int nrowszoom=2*get_rows()-1;

     Image zoom(nrowszoom, ncolszoom);

     //Cargamos la imagen original en una imagen mas grande en la posicion donde debe estar
     for(int i=0; i<nrowszoom; i+=2){
         for (int j=0; j<ncolszoom; j+=2){
             zoom.set_pixel(i,j, get_pixel(i/2, j/2));
         }
     }

     for (int j=1; j<ncolszoom-1; j+=2){
         for (int i=0; i<nrowszoom; i+=2){
             zoom.set_pixel(i,j , round((get_pixel(i/2, j/2)+ get_pixel(i/2, j/2+1))/2));
         }
     }

     for (int i=1; i<nrowszoom; i+=2){
         for(int j=0; j<ncolszoom; j+=2){
             zoom.set_pixel(i,j, round((get_pixel(i/2,j/2)+ get_pixel(i/2+1, j/2))/2));
         }
     }

     for (int i=1; i<nrowszoom-1; i+=2){
         for (int j=1; j<ncolszoom-1; j+=2){
             zoom.set_pixel(i,j, round((zoom.get_pixel(i-1, j-1)+zoom.get_pixel(i-1,j+1)+zoom.get_pixel(i+1,j-1)+zoom.get_pixel(i+1, j+1))/4));
         }
     }

     return zoom;
}
// Genera un icono como reducción de una imagen.
Image Image::Subsample(int factor) const{
    int nrows = rows/factor;
    int ncols = cols/factor;
    Image subsample(nrows,ncols);
    
    for (int i= 0; i<ncols; i++){
        for (int j=0; j<nrows; j++){
            byte nuevo = round(this->Mean(i*factor, j*factor, factor, factor));
            subsample.set_pixel(i,j,nuevo);
        }
    }
    return subsample;
}

// Modifica el contraste de una Imagen .
void Image::AdjustContrast (byte in1, byte in2, byte out1, byte out2){
    byte nuevo =0;
    for(int i=0;i<cols;i++){
        for (int j=0;j<rows;j++){
            if((this->get_pixel(i,j) >=0) && (this->get_pixel(i,j) < in1)){
                nuevo = 
            }else if((this->get_pixel(i,j) >=in1) && (this->get_pixel(i,j) < in2)){
                
            }else if ((this->get_pixel(i,j) >=in2) && (this->get_pixel(i,j) <= 225))
        }
    }
}

double Image::Mean(int i, int j, int height, int width) const {
    int suma = 0;

    for (int row = i; row < i + height; ++row) {
        for (int col = j; col < j + width; ++col) {
            suma += this->get_pixel(row, col);
        }
    }
    return (double) suma / (height * width);
}
