#include <iostream>
#include <fstream>
#include <sstream>
#include <map>
#include <vector>

using namespace std;

int main(int argc ,char * argv[] ) {
    std::ifstream archivoEntrada; // Nombre del archivo de entrada
    std::ofstream archivoSalida; // Nombre del archivo de salida

    archivoEntrada.open(argv[1]);
    archivoSalida.open(argv[2]);

    if (!archivoEntrada.is_open()) {
        std::cout << "Error al abrir el archivo de entrada." << std::endl;
        return 1;
    }

    if (!archivoSalida.is_open()) {
        std::cout << "Error al abrir el archivo de salida." << std::endl;
        return 1;
    }

    std::map<std::string, std::string> abreviaturas;
    vector<string> abvs , defs;
    std::string def , ab;
    int pos1 , pos2;
    std::string linea;
    while (std::getline(archivoEntrada, linea)) {
        pos1 = linea.find('|');
        pos2 = linea.find(' ');
        ab = linea.substr(0,pos2);
        abvs.push_back(ab);
        def = linea.substr(pos1+2, linea.size());
        defs.push_back(def);

    }

    for(int i = 0 ; i < abvs.size(); ++i){
        archivoSalida << abvs[i] << endl;
    }
    
    for(int i = 0 ; i < defs.size(); ++i){
        archivoSalida << defs[i] << endl;
    }
    std::cout << "Archivo de salida generado correctamente." << std::endl;

    archivoEntrada.close();
    archivoSalida.close();

    return 0;
}
