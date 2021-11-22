#include <iostream>
#include <vector>

using namespace std;

#include "Tablero.h"
#include "FuncionesAuxiliares.h"
#include "JugadorGoloso.h"
//LOS RENOMBRES DE LOS TIPOS DE DATOS ESTAN EN FUNCIONESAUXILIARES

int main(int argc, char const * argv[]) {
	if(argc <= 3){
	    while (true) {
	        jugadorgoloso(9397, 7028, 50, -54);

	        //jugadorgoloso(3700,928,1,-1); 
	       
	    }
	}else{
		while(true){
			jugadorgoloso(stoi(argv[1]),stoi(argv[2]),stoi(argv[3]),stoi(argv[4]));

		}

	}
    return 0;
}