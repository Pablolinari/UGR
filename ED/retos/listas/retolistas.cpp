#include<list>
#include<iostream>
#include<utility>


using namespace std;
typedef pair<int,int> intervalo;

bool Extraer(list<intervalo> & l1 , intervalo x , list<intervalo> & l2 ){
    bool es_posible = true , continua = true , continua2 = true;
    list<intervalo>::iterator it , pos,it2;
    it=l1.begin();
    while (it!=l1.end() && continua)
    {
        if(*it->first() >= x.first() && *it->second() <= x.second()){
            continua = false;
            pos = it;
        }
        it++;
    }
    if(!continua){
        it2 = l2.begin();
        while(it2 != l2.end() && continua2){
            if()
        }
    }

}
    int main(){
        list <int> nueva;

    return 0;
    }