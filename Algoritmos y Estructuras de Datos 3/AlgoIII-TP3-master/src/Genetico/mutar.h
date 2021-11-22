#ifndef TP3_MUTAR
#define TP3_MUTAR

#include <random>
using namespace std;
#include "funciones_auxiliares.h"
#include "juez.h"

const float MUTACION = 0.05;


struct hijos{
	vector<int> hijo1;
	vector<int> hijo2;
};



void mutar(vector<int> &genes);
hijos crossover(vector<int> gen1,vector<int>  gen2);
vector<int> seleccion_ponderada(vector<float> &puntajes);
vector<int> seleccion_random(vector<vector<int> > &poblacion);


#endif //TP3_MUTAR
