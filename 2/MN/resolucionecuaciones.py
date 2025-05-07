from numpy import sign
from Decimal import *

def todecimal(x):
    if isinstance(x, Decimal):
        return x
    else:
        return Decimal(str(x))

nmax=100
prec=10**(-20)
tol=10**(-10)
def secante(f, x0, x1, nmax=nmax, prec=prec, tol=tol):
    """
    Implementa el método de la secante para encontrar una raíz de la función f.

    Parámetros:
    -----------
    f : función
        La función cuya raíz se desea encontrar.
    x0 : float
        Primera aproximación inicial para la raíz.
    x1 : float
        Segunda aproximación inicial para la raíz.
    nmax : int
        Número máximo de iteraciones.
    prec : float
        Criterio de precisión; se detiene si |f(xn)| < prec.
    tol : float
        Criterio de tolerancia; se detiene si |x1 - xn1| < tol.

    Retorna:
    --------
    xn1 : float
        Raíz aproximada.
    niter : int
        Número de iteraciones realizadas.
    exit : str
        Condición de salida ('precision', 'tolerancia' o máximo de iteraciones alcanzado).
    """
    niter = 0
    cont = True
    exit = ''
    x0 = todecimal(x0)
    x1=todecimal(x1)
    while niter < nmax and cont:
        niter += 1
        xn1 = x1 - (((x1 - x0) / (todecimal(f(x1)) - (todecimal(f(x0))))) * f(x1))
        xn1 = todecimal(xn1)

        if abs(f(xn1)) < prec:
            exit = 'precision'
            cont = False
        
        if abs(x1 - xn1) < tol:
            exit = 'tolerancia'
            cont = False
        
        x0 = todecimal(x1)
        x1 = todecimal(xn1)

    if exit == 'precision':
        print(f'Posiblemente solución exacta: {xn1}')
    elif exit == 'tolerancia':
        print(f'Aproximación solicitada: {xn1}')
    else:
        print(f'Se llegó al número máximo de iteraciones ')
    return xn1, niter, exit

def wittaker(f, x0, m, nmax=nmax, prec=prec, tol=tol):
    """
    Implementa el método de Whittaker para encontrar una raíz de la función f.

    Parámetros:
    -----------
    f : función
        La función cuya raíz se desea encontrar.
    x0 : float
        Aproximación inicial para la raíz.
    m : float
        Parámetro de pendiente usado en la iteración.
    nmax : int
        Número máximo de iteraciones.
    prec : float
        Criterio de precisión; se detiene si |f(xn)| < prec.
    tol : float
        Criterio de tolerancia; se detiene si |x0 - xn| < tol.

    Retorna:
    --------
    xn : float
        Raíz aproximada.
    niter : int
        Número de iteraciones realizadas.
    exit : str
        Condición de salida ('precision', 'tolerancia' o máximo de iteraciones alcanzado).
    """
    niter = 0
    cont = True
    exit = ''
    while niter < nmax and cont:
        niter += 1
        xn = x0 - (f(x0) / m)

        if abs(f(xn)) < prec:
            exit = 'precision'
            cont = False

        if abs(x0 - xn) < tol:
            exit = 'tolerancia'
            cont = False
        x0=xn
    if exit == 'precision':
        print(f'Posiblemente solución exacta: {xn}')
    elif exit == 'tolerancia':
        print(f'Aproximación solicitada: {xn}')
    else:
        print(f'Se llegó al número máximo de iteraciones ')
    return xn, niter, exit

def NewtonRaphson(f, df, x0, nmax=nmax, prec=prec, tol=tol):
    """
    Implementa el método de Newton-Raphson para encontrar una raíz de la función f.

    Parámetros:
    -----------
    f : función
        La función cuya raíz se desea encontrar.
    df : función
        La derivada de la función f.
    x0 : float
        Aproximación inicial para la raíz.
    nmax : int
        Número máximo de iteraciones.
    prec : float
        Criterio de precisión; se detiene si |f(xn)| < prec.
    tol : float
        Criterio de tolerancia; se detiene si |x0 - xn| < tol.

    Retorna:
    --------
    xn : float
        Raíz aproximada.
    niter : int
        Número de iteraciones realizadas.
    exit : str
        Condición de salida ('precision', 'tolerancia' o máximo de iteraciones alcanzado).
    """
    niter = 0
    cont = True
    exit = ''
    while niter < nmax and cont:
        niter += 1
        xn = x0 - (f(x0) / df(x0))

        if abs(x0 - xn) < tol:
            exit = 'tolerancia'
            cont = False
        if abs(f(xn)) < prec:
            exit = 'precision'
            cont = False

        x0 = xn

    if exit == 'precision':
        print(f'Posiblemente solución exacta: {xn}')
    elif exit == 'tolerancia':
        print(f'Aproximación solicitada: {xn}')
    else:
        print(f'Se llegó al número máximo de iteraciones ')
    return xn, niter, exit

def biseccion(f, a, b, nmax=nmax, prec=prec, tol=tol):
    """
    Implementa el método de bisección para encontrar una raíz de la función f en el intervalo [a, b].

    Parámetros:
    -----------
    f : función
        La función cuya raíz se desea encontrar.
    a : float
        Límite inferior del intervalo.
    b : float
        Límite superior del intervalo.
    nmax : int
        Número máximo de iteraciones.
    tol : float
        Criterio de tolerancia; se detiene si |b - a| < tol.
    prec : float
        Criterio de precisión; se detiene si |f(c)| < prec.

    Retorna:
    --------
    c : float
        Raíz aproximada.
    niter : int
        Número de iteraciones realizadas.
    exit : str
        Condición de salida ('precision', 'tolerancia' o máximo de iteraciones alcanzado).
    """
    niter = 0
    cont = True
    exit = ''
    while niter < nmax and cont:
        niter += 1
        c = (a + b) / 2
        if abs(f(c)) < prec:
            exit = 'precision'
            cont = False
        elif sign(f(a)) != sign(f(c)):
            b = c
        else:
            a = c

        if b - a < tol:
            exit = 'tolerancia'
            cont = False

    if exit == 'precision':
        print(f'Posiblemente solución exacta: {c}')
    elif exit == 'tolerancia':
        print(f'Aproximación solicitada: {c}')
    else:
        print('Se llegó al número máximo de iteraciones')
    return c, niter, exit

def Steffensen(f,x0, nmax=nmax, prec=prec, tol=tol):
    """
    Implementa el método de Steffensen para encontrar una raíz de la función f.

    Parámetros:
    -----------
    f : función
        La función cuya raíz se desea encontrar.
    x0 : float
        Aproximación inicial para la raíz.
    nmax : int
        Número máximo de iteraciones.
    prec : float
        Criterio de precisión; se detiene si |f(xn)| < prec.
    tol : float
        Criterio de tolerancia; se detiene si |x0 - xn| < tol.

    Retorna:
    --------
    xn : float
        Raíz aproximada.
    niter : int
        Número de iteraciones realizadas.
    exit : str
        Condición de salida ('precision', 'tolerancia' o máximo de iteraciones alcanzado).
    """
    niter = 0
    cont = True
    exit = ''
    while niter < nmax and cont:
        niter += 1
        xn = x0 - ((f(x0)**2) / (f(x0+f(x0))-f(x0)))

        if abs(f(xn)) < prec:
            exit = 'precision'
            cont = False

        if abs(x0 - xn) < tol:
            exit = 'tolerancia'
            cont = False
        x0=xn
    if exit == 'precision':
        print(f'Posiblemente solución exacta: {xn}')
    elif exit == 'tolerancia':
        print(f'Aproximación solicitada: {xn}')
    else:
        print(f'Se llegó al número máximo de iteraciones ')
    return xn, niter, exit


def aceleracionStefffensen(f,x0,x1,x2, nmax=nmax, prec=prec, tol=tol):
    x_0=x0
    x_1=f(x0)
    x_2=f(x1)

    niter = 0
    cont = True
    exit = ''
    while niter < nmax and cont:
        niter += 1
        x_n = x_0 -(((x_1-x_0)**2)/(x_2 - 2*x_1 +x_0))

        if abs(f(x_n)) < prec:
            exit = 'precision'
            cont = False
        if abs(x0 - xn) < tol:
            exit = 'tolerancia'
            cont = False
        x_0=x_n
        x_1=f(x_n)
        x_2=f(x_1)
    if exit == 'precision':
        print(f'Posiblemente solución exacta: {xn}')
    elif exit == 'tolerancia':
        print(f'Aproximación solicitada: {xn}')
    else:
        print(f'Se llegó al número máximo de iteraciones ')
    return x_n,niter,exit
