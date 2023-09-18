#include <iostream>
#include <string>


using namespace std; 

int main(){

    cout << ".HOla pablo ";

    int min=0 ,sec=0 , rest=0, set =0;

    cin >> set >> min >> sec >> rest;

    int total_sec = sec*set + rest*set ;
   int  total_min = min;

   if (total_sec >= 60 ){
    total_min += total_sec/60;
    total_sec = total_sec%60;
   }

   cout <<total_min << " , " << total_sec;


    return 0;
}

