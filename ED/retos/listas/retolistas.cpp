#include <iterator>
#include<list>
#include<iostream>
#include <system_error>
#include<utility>
#include <vector>


using namespace std;
typedef pair<int,int> intervalo;

bool Extraer(list<intervalo> & l1 , intervalo x , list<intervalo> & l2 ){
bool pertenece = false;
list<intervalo>::iterator it , it1;
for (it = l1.begin(); it != l1.end(); ++it) {
    if ((it->first <= x.first )&& (it->second >= x.second)) {
        pertenece = true;
        it = it1;

        if(it->first > x.first ){
            l1.insert(it,intervalo(it->first,x.first));
        }        
        else if(it->second < x.second){
            l1.insert(it,intervalo(x.second,it->second));
        }
        
    }
}



return pertenece;
}

int main(){

    list<intervalo> l1 , l2;
    int n1 = 0,n2 = 0 , n = 1;

    while(n2 != -1){
        cout << "intervalo " << n << " : \n";
        cout << "Primer numero : \n";
        cin  >> n1;
        cout << "Segundo numero : \n";
        cin >>n2;
        if(n2 != -1)
            l1.push_back(intervalo(n1,n2));
        n++;
    }
    cout << "intervalo  a buscar : ";
    cout << "Primer numero : \n";
    cin  >> n1;
    cout << "Segundo numero : \n";
    cin >>n2;
    intervalo i ;
    i.first = n1;
    i.second = n2;
    

    bool extraido = Extraer(l1, i, l2);

    list<intervalo>::iterator it;
    for(it=l1.begin();it!=l1.end();++it){
        cout <<" [" <<it->first <<","<< it->second << "] ,";
    }

    return 0;
};