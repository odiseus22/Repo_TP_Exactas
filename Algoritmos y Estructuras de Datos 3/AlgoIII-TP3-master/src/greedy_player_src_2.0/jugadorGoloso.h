#ifndef TP3_JUGADORGOLOSO_H
#define TP3_JUGADORGOLOSO_H

#include "funcionesAuxiliares.h"

int evaluarTablero(const tablero &T, const int &C, const int &pesoGanar, const int &pesoPerder,
                   const int &pesoMisFilas, const int &pesoMisColumnas, const int &pesoMisDiagonales, 
                   const int &pesoSusFilas, const int &pesoSusColumnas, const int &pesoSusDiagonales,
                   const int &pesoCentro);

int jugadaGolosa(const tablero &T, const int &C, const int &pesoGanar, const int &pesoPerder,
                 const int &pesoMisFilas, const int &pesoMisColumnas, const int &pesoMisDiagonales, 
                 const int &pesoSusFilas, const int &pesoSusColumnas, const int &pesoSusDiagonales,
                 const int &pesoCentro);

void jugadorGoloso(const int &pesoGanar, const int &pesoPerder, 
				   const int &pesoMisFilas, const int &pesoMisColumnas, const int &pesoMisDiagonales, 
				   const int &pesoSusFilas, const int &pesoSusColumnas, const int &pesoSusDiagonales,
				   const int &pesoCentro);

#endif //TP3_JUGADORGOLOSO_H