#include <iostream>
#include "DisjointSetArray.hpp"
#include "DisjointSetTree.hpp"
#include "DisjointSetTreePath.hpp"
#include "takeInput.cpp"
#include <algorithm>
#include <fstream>
#include <experimental/filesystem>

using edge = tuple<int, int, int>;

int k = 10000;


//Podria ser float
int lim(int C) {
    return k / C;
}

int max2(int a, int b) {
    if (a > b)
        return a;
    return b;
}

int max3(int a, int b, int c) {
    return max2(a, max2(b, c));
}


void array_catedra() {
    int n, m, w, h; //w = width, h = height
    vector<edge> E = takeinput_catedra(n, m, w, h);

    /*  --  Kruskal  --  */
    //Sort
    sort(E.begin(), E.end());
    //Estructuras
    DisjointSetArray ds(n);
    vector<int> Intern(n, 0);
    //Genero mi segmentacion
    for (int i = 1; i < E.size(); i++) {
        int v = ds.find(first(E[i]));
        int w = ds.find(second(E[i]));
        if (v != w) {
            int MInt = min(Intern[v] + lim(ds.size(v)),
                           Intern[w] + lim(ds.size(w)));
            if (cost(E[i]) <= MInt) {
                int temp = max3(Intern[v], Intern[w], cost(E[i]));
                ds.Unite(first(E[i]), second(E[i]));
                Intern[ds.find(first(E[i]))] = temp;
            }
        }
    }
    /*  --  Fin_Kruskal -- */

    //Guardo los resultados en un txt
    for (int i = 0; i < h; i++) {
        int off = i * w;
        for (int j = 0; j < w; j++) {
            cout << ds.find(off + j) << " ";
        }
        if (i != h - 1)
            cout << endl;
    }

}

void tree_catedra() {
    int n, m, w, h; //w = width, h = height
    vector<edge> E = takeinput_catedra(n, m, w, h);

    /*  --  Kruskal  --  */
    //Sort
    sort(E.begin(), E.end());
    //Estructuras
    DisjointSetTree ds(n);
    vector<int> Intern(n, 0);
    //Genero mi segmentacion
    for (int i = 1; i < E.size(); i++) {
        int v = ds.find(first(E[i]));
        int w = ds.find(second(E[i]));
        if (v != w) {
            int MInt = min(Intern[v] + lim(ds.size(v)),
                           Intern[w] + lim(ds.size(w)));
            if (cost(E[i]) <= MInt) {
                int temp = max3(Intern[v], Intern[w], cost(E[i]));
                ds.Unite(first(E[i]), second(E[i]));
                Intern[ds.find(first(E[i]))] = temp;
            }
        }
    }
    /*  --  Fin_Kruskal -- */

    //Guardo los resultados en un txt
    for (int i = 0; i < h; i++) {
        int off = i * w;
        for (int j = 0; j < w; j++) {
            cout << ds.find(off + j) << " ";
        }
        if (i != h - 1)
            cout << endl;
    }

}

void path_catedra() {
    int n, m, w, h; //w = width, h = height
    vector<edge> E = takeinput_catedra(n, m, w, h);

    /*  --  Kruskal  --  */
    //Sort
    sort(E.begin(), E.end());
    //Estructuras
    DisjointSetTreePath ds(n);
    vector<int> Intern(n, 0);
    //Genero mi segmentacion
    for (int i = 1; i < E.size(); i++) {
        int v = ds.find(first(E[i]));
        int w = ds.find(second(E[i]));
        if (v != w) {
            int MInt = min(Intern[v] + lim(ds.size(v)),
                           Intern[w] + lim(ds.size(w)));
            if (cost(E[i]) <= MInt) {
                int temp = max3(Intern[v], Intern[w], cost(E[i]));
                ds.Unite(first(E[i]), second(E[i]));
                Intern[ds.find(first(E[i]))] = temp;
            }
        }
    }
    /*  --  Fin_Kruskal -- */

    //Guardo los resultados en un txt
    for (int i = 0; i < h; i++) {
        int off = i * w;
        for (int j = 0; j < w; j++) {
            cout << ds.find(off + j) << " ";
        }
        if (i != h - 1)
            cout << endl;
    }

}


int main() {
    cout << "Funciones requeridas por la catedra (necesitan input)" << endl;
    cout << endl << "Algoritmo con estructura de representacion en Array" << endl;
    array_catedra();
    cout << endl << "Algoritmo con estructura de representacion en Tree" << endl;
    tree_catedra();
    cout << endl<< "Algoritmo con estructura de representacion en Tree con Path Compression" << endl;
    path_catedra();
    return 0;
}