#include "jugadorGoloso.h"

int contarFilaDe(const tablero &T, int C, int color, int size, int fila){
    int cant = 0;
    int inicio = 0;
    int nulos = 0;

    //Procedimiento lineal para recorrer las filas y encontrar filas con agujeros intermedios
    for(int i=0; i<T[0].size(); i++){
        if(T[fila][i]==color){
            if(i+1-inicio==C){
                cant ++;
                if(T[fila][inicio] == 0){
                    nulos --;
                }
                inicio ++;
            }
        } else if(T[fila][i]==0){
            nulos ++;
            if(nulos > C-size){  //Adelanta el puntero inicio
                inicio ++;
                if(T[fila][inicio-1]!=0){
                    while(inicio != i+1 && T[fila][inicio] == 0){
                        inicio ++;
                    }
                }
                nulos --;
            }
            if(i+1-inicio==C){
                cant ++;
                if(T[fila][inicio] == 0){
                    nulos --;
                }
                inicio ++;
            }
        } else {  //T[fila][i] == colorOpuesto
            inicio = i+1;
            nulos = 0;
        }
    }

    return cant;
}

int contarFilasDe(const tablero &T, int C, int color, int size){
    int acum = 0;
    
    for(int i=0; i<T.size(); i++){
        acum += contarFilaDe(T, C, color, size, i);
    }

    return acum;
}

int contarFilas(const tablero &T, int C, int color){
    int cant = 0;
    vector<int> cantidades(C-2);  //Es C-2 porque no cuento las fichas como filas de 1 ni las de largo C
    
    for(int i=0; i<C-2; i++){
        cantidades[i] = contarFilasDe(T, C, color, i+2);
    }

    for(int i=0; i<cantidades.size(); i++){
        cant += (i+1)*(i+1)*cantidades[i];    //Multiplico a cada cantidad por un numero dependiendo de su largo
    }

    return cant;
}

int contarColumnaDe(const tablero &T, int C, int color, int size, int columna){
    int found = 0;
    int res = 0;

    for(int i=0; i<T.size(); i++){
        if(T[i][columna] == color){
            found += 1;
            if(found == size){
                res = 1;
                break;
            }
        }
        if(T[i][columna] != color && T[i][columna] != 0){
            break;
        }
    }

    return res;
}

int contarColumnasDe(const tablero &T, int C, int color, int size){
    int acum = 0;
    
    for(int i=0; i<T[0].size(); i++){
        acum += contarColumnaDe(T, C, color, size, i);
    }

    return acum;
}

int contarColumnas(const tablero &T, int C, int color){
    int cant = 0;
    vector<int> cantidades(C-2);  //Es C-2 porque no cuento las fichas como columnas de 1 ni las de largo C
    
    for(int i=0; i<C-2; i++){
        cantidades[i] = contarColumnasDe(T, C, color, i+2);
    }

    for(int i=0; i<cantidades.size(); i++){
        cant += (i+1)*(i+1)*cantidades[i];    //Multiplico a cada cantidad por un numero dependiendo de su largo
    }

    return cant;
}

int contarDiagonalesDe(const tablero &T, int C, int color, int size){
    int cant = 0;
    int N = T[0].size();
    int M = T.size();

    /*  Primero de abajo a la izquierda hacia la derecha  */

    // Se que esto parece un bardo pero funciona bien y es lineal con el tamano del tablero.
    // Es analogo al de las filas, asi que conviene ver ese para entenderlo.

    for(int i=M-1; i>=C-1; i--){
        int inicio = 0;
        int nulos = 0;
        for(int j=0; i-j>=0 && j >= 0; j++){
            if(T[i-j][j]==color){
                if(j+1-inicio==C){
                    cant ++;
                    if(T[i-inicio][inicio] == 0){
                        nulos --;
                    }
                    inicio ++;
                }
            } else if(T[i-j][j]==0){
                nulos ++;
                if(nulos > C-size){  
                    inicio ++;
                    if(T[i-inicio+1][inicio-1]!=0){
                        while(inicio != j+1 && T[i-inicio][inicio] == 0){
                            inicio ++;
                        }
                    }
                    nulos --;
                }
                if(j+1-inicio==C){
                    cant ++;
                    if(T[i-inicio][inicio] == 0){
                        nulos --;
                    }
                    inicio ++;
                }
            } else {  
                inicio = j+1;
                nulos = 0;
            }
        }
    }

    // i empieza desde 1 porque esa diagonal la recorri antes
    for(int i=1; i<=N-C; i++){
        int inicio = 0;
        int nulos = 0;
        for(int j=0; i+j>=0 && M-1 >= j; j++){
            if(T[M-1-j][i+j]==color){
                if(j+1-inicio==C){
                    cant ++;
                    if(T[M-1-inicio][i+inicio] == 0){
                        nulos --;
                    }
                    inicio ++;
                }
            } else if(T[M-1-j][i+j]==0){
                nulos ++;
                if(nulos > C-size){  
                    inicio ++;
                    if(T[M-1-inicio+1][i+inicio-1]!=0){
                        while(inicio != j+1 && T[M-1-inicio][i+inicio] == 0){
                            inicio ++;
                        }
                    }
                    nulos --;
                }
                if(j+1-inicio==C){
                    cant ++;
                    if(T[M-1-inicio][i+inicio] == 0){
                        nulos --;
                    }
                    inicio ++;
                }
            } else {  
                inicio = j+1;
                nulos = 0;
            }
        }
    }

    /*  De abajo a la derecha hacia arriba  */

    for(int i=C-1; i<M; i++){
        int inicio = 0;
        int nulos = 0;
        for(int j=0; i-j>=0 && N-1 >= j; j++){
            if(T[i-j][N-1-j]==color){
                if(j+1-inicio==C){
                    cant ++;
                    if(T[i-inicio][N-1-inicio] == 0){
                        nulos --;
                    }
                    inicio ++;
                }
            } else if(T[i-j][N-1-j]==0){
                nulos ++;
                if(nulos > C-size){  //Adelanta el puntero inicio
                    inicio ++;
                    if(T[i-inicio+1][N-1-inicio+1]!=0){
                        while(inicio != j+1 && T[i-inicio][N-i-inicio] == 0){
                            inicio ++;
                        }
                    }
                    nulos --;
                }
                if(j+1-inicio==C){
                    cant ++;
                    if(T[i-inicio][N-1-inicio] == 0){
                        nulos --;
                    }
                    inicio ++;
                }
            } else {  //T[fila][i] == colorOpuesto
                inicio = j+1;
                nulos = 0;
            }
        }
    }

    for(int i=N-2; i>=C-1; i--){
        int inicio = 0;
        int nulos = 0;
        for(int j=0; i+j>=0 && M-1 >= j; j++){
            if(T[M-1-j][i-j]==color){
                if(j+1-inicio==C){
                    cant ++;
                    if(T[M-1-inicio][i-inicio] == 0){
                        nulos --;
                    }
                    inicio ++;
                }
            } else if(T[M-1-j][i-j]==0){
                nulos ++;
                if(nulos > C-size){  
                    inicio ++;
                    if(T[M-1-inicio+1][i-inicio+1]!=0){
                        while(inicio != j+1 && T[M-1-inicio][i+inicio] == 0){
                            inicio ++;
                        }
                    }
                    nulos --;
                }
                if(j+1-inicio==C){
                    cant ++;
                    if(T[M-1-inicio][i+inicio] == 0){
                        nulos --;
                    }
                    inicio ++;
                }
            } else {  
                inicio = j+1;
                nulos = 0;
            }
        }
    }

    return cant;
}

int contarDiagonales(const tablero &T, int C, int color){
    int cant = 0;
    vector<int> cantidades(C-2, 0);  //Es C-2 porque no cuento las fichas como diagonales de 1 ni las de largo C
    
    for(int i=0; i<C-2; i++){
        cantidades[i] = contarDiagonalesDe(T, C, color, i+2);
    }

    for(int i=0; i<cantidades.size(); i++){
        cant += (i+1)*(i+1)*cantidades[i];    //Multiplico a cada cantidad por un numero dependiendo de su largo
    }

    return cant;
}

int contarVictoria(const tablero &T, int C, int color){
    int res;
    
    if(color == 1)
        res = contarFilasDe(T, C, color, C) + contarColumnasDe(T, C, color, C) + contarDiagonalesDe(T, C, color, C);
    else 
        res = contarFilasDe(T, C, color, C-1) + contarColumnasDe(T, C, color, C-1) + contarDiagonalesDe(T, C, color, C-1);

    return res;
}

int piezasCentrales(const tablero &T, int color){
    int acum = 0;
    int N = T[0].size();

    for(int i=0; i<T.size(); i++){
        for(int j=0; j<N; j++){
            if(T[i][j]==color){
                if(j>N/2){       //Le sumo un valor proporcional a "que tan en el centro esta".
                    acum += (N-j);
                } else {
                    acum += j;
                }
            }
        }
    }

    return acum;
}

int evaluarTablero(const tablero &T, const int &C, const int &pesoGanar, const int &pesoPerder,
                   const int &pesoMisFilas, const int &pesoMisColumnas, const int &pesoMisDiagonales, 
                   const int &pesoSusFilas, const int &pesoSusColumnas, const int &pesoSusDiagonales,
                   const int &pesoCentro){

    /*       Tiene complejidad O(NMC) pero C <= 8  (Tampoco es grave)         */
    /* Se puede hacer O(NM) analizando menos longitudes de filas, columnas... */

    int valorGanar = contarVictoria(T, C, 1);
    int valorPerder = contarVictoria(T, C, 2);
    int valorMisFilas = contarFilas(T, C, 1);
    int valorMisColumnas = contarColumnas(T, C, 1);
    int valorMisDiagonales = contarDiagonales(T, C, 1);
    int valorSusFilas = contarFilas(T, C, 2);
    int valorSusColumnas = contarColumnas(T, C, 2);
    int valorSusDiagonales = contarDiagonales(T, C, 2);
    int valorCentro = piezasCentrales(T, 1);

    return pesoGanar*valorGanar + pesoPerder*valorPerder +
           pesoMisFilas*valorMisFilas + pesoMisColumnas*valorMisColumnas + pesoMisDiagonales*valorMisDiagonales + 
           pesoSusFilas*valorSusFilas + pesoSusColumnas*valorSusColumnas + pesoSusDiagonales*valorSusDiagonales + 
           pesoCentro*valorCentro;
}

int jugadaGolosa(tablero &T, const int &C, 
                 const int &pesoGanar, const int &pesoPerder,
                 const int &pesoMisFilas, const int &pesoMisColumnas, const int &pesoMisDiagonales, 
                 const int &pesoSusFilas, const int &pesoSusColumnas, const int &pesoSusDiagonales, 
                 const int &pesoCentro) {


    int N = T[0].size();
    int puntajeActual = negInf;
    int jugadaActual = -1;
    int i = 0;


    while (i < N) {//Pongo cada ficha, veo su puntaje y la saco
        int valorJugada;
        if (esValida(T, i)) { //Si la columna esta llena no puedo poner una ficha
            ponerFicha(T, i, 1);
            valorJugada = evaluarTablero(T, C, pesoGanar, pesoPerder, 
                                        pesoMisFilas, pesoMisColumnas, pesoMisDiagonales,
                                        pesoSusFilas, pesoSusColumnas, pesoSusDiagonales,
                                        pesoCentro);
            if(valorJugada>puntajeActual){
                //Si encontre una jugada mejor actualizo
                puntajeActual = valorJugada;
                jugadaActual = i;
            }
            sacarFicha(T, i);
        }
        i++;
    }


    return jugadaActual;

}

void jugadorGoloso(const int &pesoGanar, const int &pesoPerder, 
                   const int &pesoMisFilas, const int &pesoMisColumnas, const int &pesoMisDiagonales, 
                   const int &pesoSusFilas, const int &pesoSusColumnas, const int &pesoSusDiagonales, 
                   const int &pesoCentro){

    string colorYo;
    string colorEl;
    int N;
    int M;
    int p;
    int C;
    string quienEmpieza;
    int turnoDe = 0;
    colorYo = read_str();
    colorEl = read_str();
    N = read_int();
    M = read_int();
    C = read_int();
    p = read_int();
    quienEmpieza = read_str();


    if (quienEmpieza == "vos") {
        turnoDe = 1;
    }
    if (quienEmpieza == "el") {
        turnoDe = 2;
    }


    //Inicializo el tablero
    tablero T(M, vector<int>(N, 0));


    int posicionFicha = -1;
    //Este bool no me parece necesario pero lo dejo por si las moscas
    bool finalizar = false;


    if (turnoDe == 1) {
        posicionFicha = jugadaGolosa(T, C, pesoGanar, pesoPerder, 
                                    pesoMisFilas, pesoMisColumnas, pesoMisDiagonales, 
                                    pesoSusFilas, pesoSusColumnas, pesoSusDiagonales,
                                    pesoCentro);
        ponerFicha(T, posicionFicha, 1);
        cout << posicionFicha << endl;
    }


    while (!finalizar) {//Hasta que termine el juego

        string msg;
        msg = read_str();

        if (msg == "ganaste" || msg == "perdiste" || msg == "empataron") {
            finalizar = true;
        } else {
            //Su jugada
            posicionFicha = stoi(msg);//tradusco a posicion de ficha
            ponerFicha(T, posicionFicha, 2);

            //Mi jugada
            posicionFicha = jugadaGolosa(T, C, pesoGanar, pesoPerder, 
                                        pesoMisFilas, pesoMisColumnas, pesoMisDiagonales, 
                                        pesoSusFilas, pesoSusColumnas, pesoSusDiagonales,
                                        pesoCentro);
            ponerFicha(T, posicionFicha, 1);
            cout << posicionFicha << endl;
        }
    }
}