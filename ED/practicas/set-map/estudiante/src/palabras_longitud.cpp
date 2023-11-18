#include <iostream>
#include "dictionary.h"
#include <string>
#include <fstream>

using namespace std ;


int main (int argc,char * argv[]){

    ifstream fi;
    Dictionary di;
    fi.open(argv[1]);
    fi >> di;
    fi.close();
    vector<string> v;

     v =  di.wordsLenght(atoi(argv[2]));

    for (int i =0;i<v.size(); i++){
        cout << v[i] << endl;
    }
    

    return 0;
}


