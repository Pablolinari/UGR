/**
 * @file maxstack.h
 * @brief  Archivo de especificación del TDA MaxStack
 * @author
 */

#include "maxqueue.h"

class MaxStack
{
private:
    element * p;
    int n;
    int reservados;
public:
    element tope();
    int nelements();
    int reservados();
    void inserta(element p);
    void quita();
    void vacia();

    

    

private:

    allocate(int n);
    delocate();
    increase(int n);
                       


};
