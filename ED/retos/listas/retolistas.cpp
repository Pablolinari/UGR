#include <ios>
#include <iostream>
#include <iterator>
#include <list>
#include <system_error>
#include <utility>
#include <vector>

using namespace std;
typedef pair<int, int> intervalo;

bool Extraer(list<intervalo> &l1, intervalo x, list<intervalo> &l2) {
  bool pertenece = false, continua = true;
  list<intervalo>::iterator it, it1;
  for (it = l1.begin(); it != l1.end() && continua; ++it) {
    if (it->first <= x.first && it->second >= x.second) {
      intervalo a(*it);
      if (a.first < x.first && a.second > x.second) {
        l1.insert(it, intervalo(a.first, x.first - 1));
        l1.insert(it, intervalo(x.second + 1, a.second));
      }
      if (a.first == x.first) {
        l1.insert(it, intervalo(x.second + 1, a.second));
      }
      else if (a.second == x.second) {
        l1.insert(it, intervalo(a.first, x.first - 1));
      }
      continua = false;
      pertenece = true;
      it = l1.erase(it);
    }
  }
  intervalo a;
  continua = true;
  it1 = l2.begin();
  bool sigue1 =true , sigue2 = true;
  auto it2=it1;
  for(it = l2.begin(); it != l2.end() && continua ; ++it){
    if(it->first >= x.first){
      a.first = x.first;
      it1 = it;
    }   
    if(it->second  <= x.second){
      a.second = x.second;
      it2 = it;
      l2.insert(it,a);
      continua  = false;
    }
    


  }
    l2.erase(it1,it2);
if(it1 == l2.end())
    cout << "hola" ;
  
  return pertenece;
}

int main() {

  list<intervalo> l1, l2;
  intervalo i;
  i.first = 12;
  i.second = 14;
  intervalo l1_1, l1_2, l1_3, l1_4, l2_2, l2_1, l2_3;
  l1_1.first = 1;
  l1_1.second = 7;
  l1_2.first = 10;
  l1_2.second = 14;
  l1_3.first = 18;
  l1_3.second = 20;
  l1_4.first = 25;
  l1_4.second = 26;
  l2_1.first = 0;
  l2_1.second = 1;
  l2_2.first = 14;
  l2_2.second = 16;
  l2_3.first = 20;
  l2_3.second = 23;

  l1.push_back(l1_1);
  l1.push_back(l1_2);
  l1.push_back(l1_3);
  l1.push_back(l1_4);
  l2.push_back(l2_1);
  l2.push_back(l2_2);
  l2.push_back(l2_3);

  list<intervalo>::iterator it;
  bool extraido = Extraer(l1, i, l2);

  for (it = l1.begin(); it != l1.end(); ++it) {
    cout << " [" << it->first << "," << it->second << "] ,";
  }
cout  << endl;
  
  for (it = l2.begin(); it != l2.end(); ++it) {
    cout << " [" << it->first << "," << it->second << "] ,";
  }
  cout << endl;
  /////////////////////////////////////////////////////

  i.first = 12;
  i.second = 20;

  l1_1.first = 1;
  l1_1.second = 7;
  l1_2.first = 10;
  l1_2.second = 22;
  l1_3.first = 25;
  l1_3.second = 26;

  l2_1.first = 0;
  l2_1.second = 1;
  l2_2.first = 14;
  l2_2.second = 16;
  l2_3.first = 20;
  l2_3.second = 23;

  l2.clear();
  l1.clear();
  l1.push_back(l1_1);
  l1.push_back(l1_2);
  l1.push_back(l1_3);
  l2.push_back(l2_1);
  l2.push_back(l2_2);
  l2.push_back(l2_3);
cout << "-------------------------------------------------------------"<<endl;
  extraido = Extraer(l1, i, l2);
  for (it = l1.begin(); it != l1.end(); ++it) {
    cout << " [" << it->first << "," << it->second << "] ,";
  }
  cout  << endl;
  for (it = l2.begin(); it != l2.end(); ++it) {
    cout << " [" << it->first << "," << it->second << "] ,";
  }
  cout << endl;
  return 0;
};