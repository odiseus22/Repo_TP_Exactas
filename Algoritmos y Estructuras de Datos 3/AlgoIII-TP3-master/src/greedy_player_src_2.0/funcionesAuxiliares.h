#ifndef TP3_CODIGO_FUNCIONESAUXILIARES_H
#define TP3_CODIGO_FUNCIONESAUXILIARES_H

#include <iostream>
#include <vector>
#include <tuple>

using namespace std;
typedef vector<vector<int>> tablero;
typedef vector<int> columna;

const int negInf = -1000000;
const bool DEBUGEAR = false;

int read_int();

string read_str();

void send(const std::string &);

void send(int);

void ponerFicha(tablero &T, const int &columna, const int &color);

void sacarFicha(tablero &T, const int &colummna);

void printTablero(tablero &T);

bool esValida(tablero &T, int columna);


#endif //TP3_FUNCIONESAUXILIARES_H