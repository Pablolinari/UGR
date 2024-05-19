#include <iostream>
#include <vector>
#include <algorithm>
#include <limits>

using namespace std;

void printSolution(const vector<int> &solution) {
    for (int city : solution) {
        cout << city << " ";
    }
    cout << endl;
}

int nextCity(int k, vector<int> &solution, const vector<vector<double>> &graph) {
    do {
        solution[k]++;
        if (solution[k] < graph.size() &&
            graph[solution[k - 1]][solution[k]] > 0 &&
            find(solution.begin(), solution.begin() + k, solution[k]) == solution.begin() + k) {
            if (k == graph.size() - 1 && graph[solution[k]][solution[0]] > 0) {
                return solution[k];
            }
            if (k < graph.size() - 1) {
                return solution[k];
            }
        }
    } while (solution[k] < graph.size());
    solution[k] = -1; // Reset to -1 as 0 is a valid city index
    return -1;
}

void tsp(vector<int> &solution, const vector<vector<double>> &graph, int k, double &best_cost, vector<int> &best_solution, double current_cost) {
    if (k == graph.size()) {
        current_cost += graph[solution[k - 1]][solution[0]]; // Add cost to return to the starting city
        if (current_cost < best_cost) {
            best_cost = current_cost;
            best_solution = solution;
        }
    } else {
        do {
            solution[k] = nextCity(k, solution, graph);
            if (solution[k] != -1) {
                tsp(solution, graph, k + 1, best_cost, best_solution, current_cost + graph[solution[k - 1]][solution[k]]);
            }
        } while (solution[k] != -1);
    }
}

int main() {
    int numCities;
    cout << "Enter the number of cities: ";
    cin >> numCities;

    vector<vector<double>> graph(numCities, vector<double>(numCities));
    cout << "Enter the adjacency matrix (use 0 for no direct path):" << endl;
    for (int i = 0; i < numCities; ++i) {
        for (int j = 0; j < numCities; ++j) {
            cin >> graph[i][j];
        }
    }

    vector<int> solution(numCities, -1); // Initialize with -1, to be filled with city indices
    solution[0] = 0; // Start at city 0

    double best_cost = numeric_limits<double>::max();
    vector<int> best_solution;

    tsp(solution, graph, 1, best_cost, best_solution, 0);

    if (!best_solution.empty()) {
        cout << "The best solution found is: ";
        printSolution(best_solution);
        cout << "With a cost of: " << best_cost << endl;
    } else {
        cout << "No solution found." << endl;
    }

    return 0;
}
