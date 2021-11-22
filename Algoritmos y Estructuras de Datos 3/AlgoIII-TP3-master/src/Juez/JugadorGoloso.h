#ifndef TP3_CODIGO_JUGADORGOLOSO_H
#define TP3_CODIGO_JUGADORGOLOSO_H

#include "funciones_auxiliares.h"
#include "Tablero.h"
//LOS RENOMBRES DE LOS TIPOS DE DATOS ESTAN EN FUNCIONESAUXILIARES

void
contador(int &Clinea, int &enemigogana, vector<int> &cantyoseguidos, vector<int> &cantenemigoseguidos, int &acumulado,
         int &color, int &coloranterior, bool &libre, const int &c, int &ganador);

conteo recorrer(const tableroconalturas &T, const int &c);

int evaluartablero(const tableroconalturas &T, const int &c, const int &pClinea, const int &penemigogana,
                   const int &pcantyoseguidos, const int &pcantenemigoseguidos);

int jugadagolosa(tableroconalturas &T, const int &c, const int &pClinea, const int &penemigogana,
                 const int &pcantyoseguidos, const int &pcantenemigoseguidos);

void
jugadorgoloso(const int &pClinea, const int &penemigogana, const int &pcantyoseguidos, const int &pcantenemigoseguidos);

#endif //TP3_CODIGO_JUGADORGOLOSO_H
