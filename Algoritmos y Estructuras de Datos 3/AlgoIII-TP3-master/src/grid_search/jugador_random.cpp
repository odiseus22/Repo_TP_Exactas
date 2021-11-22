
#include "jugador_random.h"



	
//random
random_device rd;
mt19937 generator(rd());

int jugadaRandom(tableroconalturas &T1){

	
	int move;

	//Obtengo filas y columnas
	tablero t1 = get<1>(T1);
	
	int columns = t1[0].size();
	int rows = t1.size();

	vector<int> alturas = get<0>(T1);

	

	uniform_int_distribution<int> do_move(0, columns - 1);


    do {
        move = do_move(generator);
    } while(alturas[move] >= rows);

	return move;
	

}

