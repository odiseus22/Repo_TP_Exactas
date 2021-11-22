#include "juez.h"

using namespace std;


int ganador(tablero &t, int c){
    int rows = t.size();
    int cols = t[0].size();
    int linea = 0;
    int color = 0;

    int ganador = 0;


    //Para debugear
    //printf("\n \n \n");
    //printTablero(t);

    //Busqueda horizontal
    for(int i = 0; i<rows && ganador == 0;i++){
        color = 0;
        for(int j = 0; j < cols;j++){
            //si es una fila del mismo color
            if(hayGanador(j,i,t,color,linea, c,ganador)){
                break;
            }

        }
    }


   
    //Busqueda vertical
    for(int i = 0; i< cols && ganador == 0; i++){
        color = 0;
        for(int j = 0; j<rows; j++){
            if(hayGanador(i,j,t,color,linea, c,ganador)){
                break;
            }
            
        }
        
    }
    

    //Busqueda diagonal "/" 

    //Para cada elemento de la primera columna veo su diagonal
    for(int i = 0; i < rows && ganador == 0; i++){
        int j = 0;
        int k = i;
        color = 0;
        while(k < rows && j < cols){
            //Si hay una ficha y es el mismo color que la anterior
            if(hayGanador(j,k,t,color,linea, c,ganador)){
                break;
            }
            j++;
            k++;

        }
        
        
    }

    //Para cada elemento de la primera fila (menos el primero)
    for(int i = 1; i< cols && ganador == 0 ; i++){
        int k = 0;
        int j = i;
        color = 0;
        //Recorro diagonal
        while(k < rows && j < cols){
            //Si hay una ficha y es el mismo color que la anterior
            if(hayGanador(j,k,t,color,linea, c,ganador)){
                break;
            }
            j++;
            k++;
        }
    }

    //Busqueda diagonal "\"

    //Primero reviso todas las diagonales saliendo de la ultima columna (todo el espacio marcado por y)
    //y y y y
    //x y y y
    //x x y y
    //x x x y

    for(int i = 0  ; i < rows && ganador == 0;i++){  
        int j = i;
        int k = cols-1;
        color = 0;
        while(k >= 0 && j < rows){
            if(hayGanador(k,j,t,color,linea, c,ganador)){
                break;
            }
            j++;
            k--;
            
        }
    }

    //Ahora reviso las diagonales saliendo de la primera fila (espacio marcado por x)
    //y y y y
    //x y y y
    //x x y y
    //x x x y

    for(int i = cols-2; i >= 0 && ganador == 0; i--){
        int j = 0;
        int k = i;
        color = 0;

        while(k>= 0 && j < rows){
            if(hayGanador(k,j,t,color,linea, c,ganador)){
                break;
            }
            j++;
            k--;
        }

    }


    //Checkear si no hay empate


    return ganador;
}


void realizarJugada(vector<int> &jugador, tableroconalturas &T1,  tableroconalturas &T2, int c){
    int posicionficha = 0;
    
    //Realiza jugada jugador 1
    if(jugador[0] == GOLOSO){

        posicionficha = jugadagolosa(T1, c, jugador[1], jugador[2], jugador[3], jugador[4]);
        //aumento la cantidad de jugadas


        

    }else{
        posicionficha = jugadaRandom(T1);
    }
    //cerr << "jugada: "<< posicionficha << endl;

    //agrega la ficha en ambos tableros
    ponerficha(T1, posicionficha, 1);
    ponerficha(T2, posicionficha, 2);

}

//(Jugador[0] = 1) = goloso
//(Jugador[0] != 1) = random
//Los demas parametros son puntajes


result juez(int M,int N,int c, int p, vector<int> &jugador1, vector<int> &jugador2){
    
 
    //Por como funciona jugador goloso, requiero un tablero para cada uno.
    tableroconalturas T1 = iniciartablero(N, M);
    tableroconalturas T2 = iniciartablero(N, M);

    
    tablero t1, t2;
    
    
    result res;
    res.cant_jugadas = 0;
    res.ganador = 0;

    while(res.cant_jugadas < 2*p && res.cant_jugadas < M*N){

        
        //Realiza jugada jugador 1
        realizarJugada(jugador1, T1,T2,c);

   
        //Obtengo mi tablero
        t1 = get<1>(T1);    
        res.cant_jugadas++;

        
        //Revisa ganadores
        if(ganador(t1,c) != 0){
            res.ganador = 1;
            return res;
        }


        
        //Revisa que haya espacio para realizar otra jugada caso contrario empatan
        if(res.cant_jugadas >= M*N){
            break;
        }
        

        //Realiza jugada jugador 2
        realizarJugada(jugador2, T2,T1,c);
         
        res.cant_jugadas++;
        //Revisa ganadores
        tablero t2 = get<1>(T2);
        if(ganador(t2,c) != 0){
            res.ganador = 2;
            return res;
        }

    }


// Codigo debugeo tablero custom
/*
    tableroconalturas T3 = iniciartablero(N, M);
    tablero t3 = get<1>(T3);
    //Insertar jugadas aqui
    printTablero(t3);
    cout << "Ganador: "<< ganador(t3,c) << endl;

*/
    //Si llego aca es empate    
    return res;
}
