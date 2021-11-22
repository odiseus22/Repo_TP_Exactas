#ifndef TP3_CODIGO_FUNCIONESAUXILIARES_H
#define TP3_CODIGO_FUNCIONESAUXILIARES_H

#include <iostream>
#include <vector>
#include <tuple>
#include <random> 
using namespace std;
typedef vector<vector<int>> tablero;
typedef vector<int> columna;
typedef tuple<columna, tablero> tableroconalturas;        //GUARDO vector con que altura tiene cada columna y el tablero en si
typedef tuple<int, int, vector<int>, vector<int>, int> conteo;

const int negInf = -32000;
const bool DEBUGEAR = false;
const int INFINITONEGATIVO = -32000;
const int GOLOSO = 1;
const int RANDOM = 2;

void ponerFicha(tablero &T, const int &columna, const int &color);
void printTablero(tablero &T);
bool hayGanador(int &indice_columna, int &indice_fila,tablero &t, int &color, int &linea, const int c, int &ganador);




struct result{
	int ganador;
	int cant_jugadas;
};
#endif //TP3_FUNCIONESAUXILIARES_H