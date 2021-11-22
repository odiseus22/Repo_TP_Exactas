#ifndef TP3_CODIGO_TABLERO_H
#define TP3_CODIGO_TABLERO_H

#include "funciones_auxiliares.h"
//LOS RENOMBRES DE LOS TIPOS DE DATOS ESTAN EN FUNCIONESAUXILIARES

tableroconalturas iniciartablero(const int &N, const int &M);

void ponerficha(tableroconalturas &T, const int &caercolummna, const int &color);

void sacarficha(tableroconalturas &T, const int &caercolummna);

#endif //TP3_CODIGO_TABLERO_H
