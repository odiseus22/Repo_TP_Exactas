#include "funciones_auxiliares.h"

void printTablero(tablero &T){
    for(int i=0; i<T.size(); i++){
        cout << "|";
        for(int j=0; j<T[i].size(); j++){
            cout << T[i][j] << "|";
        }
        cout << endl;
    }
}

void ponerFicha(tablero &T, const int &columna, const int &color) {
    for(int i=0; i<T.size(); i++){
        if(T[T.size()-i-1][columna]==0){
            T[T.size()-i-1][columna]=color;
            break;
        }
    }
}


bool hayGanador(int &indice_columna, int &indice_fila,tablero &t, int &color, int &linea, const int c, int &ganador){
    if(color == t[indice_fila][indice_columna] && color != 0){
        linea++;
    }else{
        linea = 1;
        color = t[indice_fila][indice_columna];
    }
    
    if(linea>=c && color != 0){
        ganador = color;
        return true;
    }    

    return false;
}
    