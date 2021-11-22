#include "funcionesAuxiliares.h"

int read_int() {
    string msg;
    cin >> msg;
    if (msg == "salir") {
        cout << "listo" << endl;
        exit(0);
    }
    return stoi(msg);
}

string read_str() {
    string msg;
    cin >> msg;
    if (msg == "salir") {
        cout << "listo" << endl;
        exit(0);
    }
    return msg;
}

void send(const std::string &msg) {
    std::cout << msg << std::endl;
}

void send(int msg) {
    std::cout << msg << std::endl;
}

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

void sacarFicha(tablero &T, const int &columna) {
    for(int i=0; i<T.size(); i++){
        if(T[i][columna]!=0){
            T[i][columna]=0;
            break;
        }
    }
}

bool esValida(tablero &T, int columna){
    return (T[0][columna] == 0);
}