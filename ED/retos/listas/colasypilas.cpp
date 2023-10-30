#include <stack>
#include <queue>
#include <iostream>

using namespace std;
// Ejercicio 4
void imprimepila(stack<int> &pila)
{
    stack<int> aux;
    while (!pila.empty())
    {
        cout << pila.top() << endl;
        aux.push(pila.top());
        pila.pop();
    }
    while (!aux.empty())
    {
        pila.push(aux.top());
        aux.pop();
    }
}
void imprimecola(queue<int> &q1)
{
    queue<int> aux;
    while (!q1.empty())
    {
        cout << q1.front() << endl;
        aux.push(q1.front());
        q1.pop();
    }
    while (!aux.empty())
    {
        q1.push(aux.front());
        aux.pop();
    }
}
void lexico_stack(int n)
{
    stack<int> s1;
    stack<int> s2;
    s1.push(0);
    int k = 0;


    while (!s1.empty())
    {

        cout << "---" << endl;
        if (s1.top() < n)
        {
            s1.push(s1.top() + 1);
            imprimepila(s1);
        }
        if (s1.top() == n)
        {
            s1.pop();
            n = s1.top();
            s1.pop();
            s1.push(k + 1);
            imprimepila(s1);
        }
    }
}

// ejercicio 13

stack<int> mergeSorted(stack<int> a, stack<int> b)
{
    stack<int> aux;

    while (!a.empty() && !b.empty())
    {
        if (a.top() < b.top())
        {
            aux.push(a.top());
            a.pop();
        }
        else if (a.top() > b.top())
        {
            aux.push(b.top());
            b.pop();
        }
        else
        {
            aux.push(a.top());
            b.pop();
            a.pop();
        }
    }
    if (!a.empty())
    {
        while (!a.empty())
        {
            aux.push(a.top());
            a.pop();
        }
    }
    if (!b.empty())
    {
        while (!b.empty())
        {
            aux.push(b.top());
            b.pop();
        }
    }
    stack<int> final;

    while (!aux.empty())
    {
        final.push(aux.top());
        aux.pop();
        cout << "hola\n";
    }

    return final;
}

/// ejercicio 48

queue<int> multi_interseccion(queue<int> &q1, queue<int> &q2)
{
    queue<int> inter;
    while (!q1.empty() && !q2.empty())
    {
        if (q1.front() == q2.front())
        {
            inter.push(q1.front());
            q1.pop();
            q2.pop();
        }
        else if (q1.front() < q2.front())
        {
            q1.pop();
        }
        else if (q2.front() < q1.front())
        {
            q2.pop();
        }
    }
    return inter;
}

// Ejercicio 27

void creciente(queue<int> &q)
{
    queue<int> aux;
    aux.push(q.front());
    q.pop();
    while (!q.empty())
    {
        if (q.front() >= aux.front())
        {
            aux.push(q.front());
            q.pop();
        }
        else
        {
            q.pop();
        }
    }
    while (!aux.empty())
    {
        q.push(aux.front());
        q.pop();
    }
}
// Ejercicio 26

void flota_pares(stack<int> & p){
    stack<int> par ,impar;
    while(!p.empty()){
        if(p.top()%2 == 0){
            par.push(p.top());
            p.pop();
        }
        else{
            impar.push(p.top());
            p.pop();
        }
    }
    while(!par.empty()){
        p.push(par.top());
        par.pop();
    }
    while(!impar.empty()){
        p.push(impar.top());
        impar.pop();
    }
}
//Ejercicio 47

queue<int> mergesortedqueues(queue<int> q1, queue<int> q2){
    queue<int> q3;
    while(!q1.empty() && !q2.empty()){
        if(q1.front()< q2.front()){
            q3.push(q1.front());
            q1.pop();
        }
        else if(q2.front()< q1.front()){
            q3.push(q2.front());
            q2.pop();
        }
        else{
            q3.push(q2.front());
            q3.push(q2.front());
            q2.pop();
            q1.pop();
            
        }
    }
    while(!q1.empty()){
        q3.push(q1.front());
        q1.pop();
    }
    while(!q2.empty()){
        q3.push(q2.front());
        q2.pop();
    }
    return q3;
}



int main()
{
    deque<int>p11={0,2,4,6,8}; deque<int>p22={1,3,5,7,9};
    stack<int> p1(p11), p2;
    queue<int> q1(p11) ,q2(p22) ,q3;
    q3 = mergesortedqueues(q1,q2);
    imprimecola(q3);
    

    return 0;
}