/**
 * @file maxstack.cpp
 * @brief  Archivo de implementación del TDA MaxStack
 * @author
 */

    #include "MaxStack.h"

    
    element MaxStack::tope(){
        return *(p+n-1);

    }
    
    int MAxStack::nelements(){
        return n;
    }

    int MaxStack::reservados(){
        return reservados;
    }

    MaxStack::delocate()
    {
    }
    void inserta(element p)
    {
        if(n < reservados){
            *(p+n)=p;
            n++;
        }
        else{
            this->increase(2*reservados);
            *(p+n)=p;
            n++;
        }
    }
    