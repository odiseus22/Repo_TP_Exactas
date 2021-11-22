#ifndef TP3_CODIGO_FUNCIONESAUXILIARES_H
#define TP3_CODIGO_FUNCIONESAUXILIARES_H

#include <iostream>
#include <vector>
#include <tuple>
#include <stdio.h>

using namespace std;
typedef vector<vector<int>> tablero;
typedef vector<int> columna;
typedef tuple<columna, tablero> tableroconalturas;        //GUARDO vector con que altura tiene cada columna y el tablero en si
typedef tuple<int, int, vector<int>, vector<int>, int> conteo;
//int Clinea; int enemigogana; vector<int> cantyoseguidos; vector<int> cantenemigoseguidos; int ganador; se utiliza para contar en el tablero

const int INFINITONEGATIVO = -32000;
const bool DEBUGEAR = false;


int read_int();

string read_str();

void send(const std::string &);

void send(int);

int jugar(const int &iterations, const int &columns, const int &rows, const int &p, const int &c, const string &first,
          const string &opponent);

#endif //TP3_CODIGO_FUNCIONESAUXILIARES_H
