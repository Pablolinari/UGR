
#include <list>
#include <utility>
#include <iostream>


using namespace std;
typedef pair<int, int> intervalo;

// bool Extraer(list<intervalo> &l1, intervalo x, list<intervalo> &l2) {
//   bool pertenece = false, continua = true;
//   list<intervalo>::iterator it, it1;
//   for (it = l1.begin(); it != l1.end() && continua; ++it) {
//     if (it->first <= x.first && it->second >= x.second) {
//       intervalo a(*it);
//       if (a.first < x.first && a.second > x.second) {
//         l1.insert(it, intervalo(a.first, x.first - 1));
//         l1.insert(it, intervalo(x.second + 1, a.second));
//       }
//       if (a.first == x.first) {
//         l1.insert(it, intervalo(x.second + 1, a.second));
//       }
//       else if (a.second == x.second) {
//         l1.insert(it, intervalo(a.first, x.first - 1));
//       }
//       continua = false;
//       pertenece = true;
//       it = l1.erase(it);
//     }
//   }
//   intervalo a;
//   continua = true;
//   it1 = l2.begin();
//   bool sigue1 =true , sigue2 = true;
//   auto it2=it1;
//   for(it = l2.begin(); it != l2.end() && continua ; ++it){
//     if(it->first >= x.first){
//       a.first = x.first;
//       it1 = it;
//     }  
//     if(it->second  >= x.second){
//       a.second = it->second;
//       it2 = it;
//       continua  = false;
//       it = l2.erase(it1,++it2);
//       l2.insert(it,a);
//     }
    


//   }
//   return pertenece;
// }

bool Extraer(list<intervalo> &l1, intervalo x, list<intervalo> &l2) {
    bool pertenece = false;

    // Iterador para recorrer l1
    auto it = l1.begin();
    while (it != l1.end()) {
        // Verifica si x está completamente dentro de un intervalo en l1
        if (it->first <= x.first && it->second >= x.second) {
            pertenece = true;

            // Si el intervalo es más grande que x, divide el intervalo en l1
            if (it->first < x.first) {
                l1.insert(it, make_pair(it->first, x.first - 1));
                it++;
            }
            if (it->second > x.second) {
                l1.insert(it, make_pair(x.second + 1, it->second));
                it++;
            }
            // Borra el intervalo que contenía a x
            it = l1.erase(it);
        } else if (it->first > x.second) {
            // Si el intervalo actual en l1 está después de x, se termina la búsqueda
            break;
        } else {
            // Avanza al siguiente intervalo en l1
            it++;
        }
    }

    // Iterador para recorrer l2
    auto it2 = l2.begin();
    while (it2 != l2.end()) {
        // Busca el primer intervalo en l2 que comience después de x
        if (it2->first > x.first) {
            // Busca el primer intervalo en l2 que termine después de x
            while (it2 != l2.end() && it2->second < x.second) {
                it2++;
            }
            // Si el intervalo termina después de x, lo actualiza en l2
            if (it2 != l2.end() && it2->first <= x.second) {
                it2->first = x.second + 1;
            }
            break;
        }
        it2++;
    }

    // Inserta el intervalo x en l2
    l2.push_back(x);

    return pertenece;
}


void printList(const list<intervalo> &lst) {
    for (const auto &interval : lst) {
        cout << "[" << interval.first << ", " << interval.second << "] ";
    }
    cout << endl;
}


int main() {
    list<intervalo> L1 = {{1, 7}, {10, 14}, {18, 20}, {25, 26}};
    list<intervalo> L2 = {{0, 1}, {14, 16}, {20, 23}};
    intervalo x1 = {12, 14};

    cout << "Antes de Extraer:\nL1: ";
    printList(L1);
    cout << "L2: ";
    printList(L2);

    Extraer(L1, x1, L2);

    cout << "\nDespués de Extraer:\nL1: ";
    printList(L1);
    cout << "L2: ";
    printList(L2);

    return 0;
}
