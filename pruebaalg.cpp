#include <vector>
#include <algorithm>
#include <limits>
#include <iostream>

using namespace std;

double bound1(const vector<int>& path, const vector<vector<double>>& graph) {
    double bound = 0.0;
    for (int i = 0; i < graph.size(); i++) {
        if (find(path.begin(), path.end(), i) == path.end()) {
            double minDistance = numeric_limits<double>::max();
            for (int j = 0; j < graph.size(); j++) {
                if (i != j && graph[i][j] < minDistance) {
                    minDistance = graph[i][j];
                }
            }
            bound += minDistance;
        }
    }
    return bound;
}

double bound2(const vector<int>& path, const vector<vector<double>>& graph) {
    double bound = 0.0;
    for (int i = 0; i < graph.size(); i++) {
        if (find(path.begin(), path.end(), i) == path.end()) {
            double minDistance = numeric_limits<double>::max();
            for (int j : path) {
                if (graph[i][j] < minDistance) {
                    minDistance = graph[i][j];
                }
            }
            bound += minDistance;
        }
    }
    return bound;
}

double bound3(const vector<int>& path, const vector<vector<double>>& graph) {
    double bound = 0.0;
    int lastVisited = path.back();
    for (int i = 0; i < graph.size(); i++) {
        if (find(path.begin(), path.end(), i) == path.end()) {
            bound += graph[lastVisited][i];
        }
    }
    return bound;
}

double bound4(const vector<int>& path, const vector<vector<double>>& graph) {
    double bound = 0.0;
    int firstVisited = path.front();
    for (int i = 0; i < graph.size(); i++) {
        if (find(path.begin(), path.end(), i) == path.end()) {
            bound += graph[firstVisited][i];
        }
    }
    return bound;
}

bool promising(int node, const vector<int>& path, const vector<vector<double>>& graph, double (*bound)(const vector<int>&, const vector<vector<double>>&)) {
    if (find(path.begin(), path.end(), node) != path.end()) {
        return false;
    }
    double boundValue = bound(path, graph);
    // Implementa la lógica para decidir si el nodo es prometedor en base a la cota
    return true;
}

void tsp(int node, vector<int>& path, const vector<vector<double>>& graph, double (*bound)(const vector<int>&, const vector<vector<double>>&)) {
    path.push_back(node);
    if (path.size() == graph.size()) {
        // Imprime la solución si todos los nodos han sido visitados
        for (int node : path) {
            cout << node << " ";
        }
        cout << endl;
    } else {
        for (int i = 0; i < graph.size(); i++) {
            if (promising(i, path, graph, bound)) {
                tsp(i, path, graph, bound);
            }
        }
    }
    path.pop_back();
}

int main() {
    vector<vector<double>> graph = {
        // Define tu grafo aquí
    };
    vector<int> path;
    // Elige la función de cota antes de ejecutar el programa
    double (*bound)(const vector<int>&, const vector<vector<double>>&);
    bound = bound1; // o bound = bound2; o bound = bound3; o bound = bound4;
    tsp(0, path, graph, bound);
    return 0;
}
