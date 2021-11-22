
#include "juez.h"
#include <stdlib.h>

vector<int> RANDOM_PLAYER = {2};

/*   Flags   */

bool testRandom = true; //La busqueda es guiada por partidas contra random
bool testPlayer = true;//La busqueda es guiada por la bateria de jugadores
bool stopIfRatioFound = false;//La busqueda se detiene al alcanzar un ciero ratio de victoria.
bool Info = true;
bool ManySeedsTest = false;


/*  Control de iteraciones */

int cantSeeds = 10;

	

/*   4 en linea estandar   */

int N = 7;
int M = 6;
int C = 4;
int p = 21;


/*     Jugador Inicial     */

vector<int> player = {1, 2000, 2000, 100, 100};

bool improved = false;


/*  Jugadores para comparar performance  */

vector<vector<int> > players = {
	{1, 9600, 5600, 10, 40},
	{1, 12100, 5100, 280, 240},
	{1, 10900, 4900, 210, 130},
	{1, 19500, 2400, 360, 520},
	{1, 3600, 2200, 30, -10},
	{1, 4800, 4200, 50, -40},
	{1, 3200, 4700, 10, -10},
	{1, 1000, 500, 20, 20},
	{1, 4800, 3100, 20, -20},
	{1, 5400, 4400, 40, -50},
	{1, 3700, 4200, 50, -0},
	{1, 5000, 300, 80, 10},
	{1, 8000, 2000, 10, -10},
	{1, 1600, 1700, 130, 70},
	{1, 7200, 5800, 30, 20},
	{1, 1600, 1200, 40, 10},
	{1, 12000, 3000, -10, -10},
	{1, 2300, 2300, 120, 60},
	{1, 2600, 3700, 40, -40},
	{1, 3800, 4100, 40, -40},
	{1, 3900, 4400, 10, -10},
	{1, 1600, 4100, 190, 70},
	{1, 7100, 4200, 80, -30},
	{1, 10000, 4200, 100, -30},
	{1, 10400, 3900, 90, -10},
	{1, 6200, 2300, 100, 40},
	{1, 10500, 2600, 50, -20},
	{1, 9400, 2900, 50, -20}
};


/*   Seeds   */

vector<vector<int> > seeds = {
	{1, 9600, 5600, 10, 40},
	{1, 5000, 5100, 9000, 300},
	{1, 1000, 4900, 210, 8500},
	{1, 7000, 8300, 750, 520},
	{1, 3600, 850, 7200, 1000},
	{1, 700, 700, 900, 7100},
	{1, 1200, 4700, 8900, 2800},
	{1, 3000, 8000, 20, 3100},
	{1, 4800, 3100, 20, 140},
	{1, 5400, 1500, 40, },
	{1, 3700, 4200, 50, -0},	
};

/*  Auxiliares  */

void copiar(vector<int> &v, vector<int> &vCopy){
	for(int i=0; i<v.size(); i++) vCopy[i] = v[i];
}

void printPlayer(vector<int> player){
	cout << "{";
	for(int i=1; i<player.size()-1; i++){
		cout << player[i] << ", ";
	}
	cout << player[player.size()-1] << "}";
}


/*  Optimizacion  */

double test_strategy_players(vector<int> &player){
	double ratio = 0;
	for(int i=0; i<players.size(); i++){
		if(juez(7, 6, 4, 21, player, players[i]).ganador == 1)
			ratio ++;
		if(juez(7, 6, 4, 21, players[i], player).ganador == 2)
			ratio ++;
	}
	return (ratio / (2*players.size()));
}

double test_strategy_random(vector<int> &player, int matches){
	double ratio = 0;
		
	/*   Partidas comenzando greedy   */
	for(int j=0; j<matches; j++){
		if(juez(7, 6, 4, 21, player, RANDOM_PLAYER).ganador==1)
			ratio += 1;
	}

	/*   Partidas comenzando random   */
	for(int j=0; j<matches; j++){
		if(juez(7, 6, 4, 21, RANDOM_PLAYER, player).ganador==2)
			ratio += 1;
	}

	return (ratio /= (2*matches));
}

double test_strategy(vector<int> &player, int matches){
	double res;
	if(testRandom && !testPlayer) {
		res = test_strategy_random(player, matches);
	} else if (testPlayer && testRandom){
		res = (test_strategy_random(player, matches) + test_strategy_players(player))/2; 
	} else {
		res = test_strategy_players(player);
	}
	return res;
}

void cool(int &heat){
	heat -= 1;
}

bool gridImprove(vector<int> &player, int matches, int heat, double cota){
	vector<int> copy(5);
	copiar(player, copy);
	bool improved = false;
	double newRatio;

	double ratio = test_strategy(player, matches);

	player[1] += heat*10;
	newRatio = test_strategy(player, matches);
	if(newRatio > ratio){
		improved = true;
		copiar(player, copy); 
		ratio = newRatio;
	}
	player[1] -= heat*20;
	newRatio = test_strategy(player, matches);
	if(newRatio > ratio){
		improved = true;
		copiar(player, copy);
		ratio = newRatio;
	}
	player[1] += heat*10;

	player[2] += heat*10;
	newRatio = test_strategy(player, matches);
	if(newRatio > ratio){
		improved = true;
		copiar(player, copy);
		ratio = newRatio;
	}
	player[2] -= heat*20;
	newRatio = test_strategy(player, matches);
	if(newRatio > ratio){
		improved = true;
		copiar(player, copy);
		ratio = newRatio;
	}
	player[2] += heat*10;

	player[3] += heat*1;
	newRatio = test_strategy(player, matches);
	if(newRatio > ratio){
		improved = true;
		copiar(player, copy);
		ratio = newRatio;
	}
	player[3] -= heat*2;
	newRatio = test_strategy(player, matches);
	if(newRatio > ratio){
		improved = true;
		copiar(player, copy);
		ratio = newRatio;
	}
	player[3] += heat*1;

	player[4] += heat*1;
	newRatio = test_strategy(player, matches);
	if(newRatio > ratio){
		improved = true;
		copiar(player, copy);
		ratio = newRatio;
	}
	player[4] -= heat*2;
	newRatio = test_strategy(player, matches);
	if(newRatio > ratio){
		improved = true;
		copiar(player, copy);
		ratio = newRatio;
	}
	player[4] += heat*1;

	copiar(copy, player);

	if(newRatio<0.75 && testRandom && !testPlayer){
		improved = true;
	}

	return improved;
}

void Optimize(){

	int iteraciones = 500;
	int matchesIt = 500;
	int heat = 20;
	int coolIt = 50;
	double cota = 0.75;
	int infoIt = 5; 
	int parametrosIt = 50;
	int cantSeeds = 10;
	int ratioDataIt = 50;

	cout << "Paramatros iniciales: ";
	printPlayer(player);
	cout << endl;
	cout << "Optimizando con Grid Search..." << endl; 

	if(!testPlayer && !testRandom){
		cout << endl << "Error: Falta establecer una funcion objetivo" << endl;
		return;
	}

	if(Info){
		cout << "Mostrando informacion del proceso:" << endl << endl;
		cout << "Iteracion,ratioPlayer,ratioRandom,ratio" << endl;
	}

	for(int i=0; i<iteraciones; i++){

		/*  Optimizacion  */

		if(i % coolIt == 0 && heat != 1 && i != 0)
			cool(heat);

		improved = gridImprove(player, matchesIt, heat, cota);

		if(!improved && (!testRandom || stopIfRatioFound)){
			cout << endl << "Se encontraron valores optimos." << endl;
			break;	
		}		

		/*  Consola  */

		if(i % parametrosIt == 0 && i != 0 && Info){
			cout << "-Parametros tras " << i << " iteraciones -> ";
			printPlayer(player);
			cout << endl;
		}

		if(i%ratioDataIt == 0 && i != 0 && Info){
			cout << "-Ratio actual contra random: " << test_strategy_random(player, matchesIt) << "%" << endl; 
			if(testPlayer)
				cout << "-Ratio actual contra jugadores: " << test_strategy_players(player) << "%" << endl;
		}

		if(Info && i % infoIt == 0) {
			double players = test_strategy_players(player);
			double random = test_strategy_random(player, matchesIt);
			cout << i << "," <<  players << "," << random << "," << (players+random)/2 << endl; 
		}

	}

	cout << "Los parametros encontrados fueron: ";
	printPlayer(player);
	cout << endl;
	cout << "El ratio correspondiente es " << test_strategy_random(player, matchesIt) << endl << endl; 
}

int main(int argc, char *argv[]){

	if(!ManySeedsTest){
		Optimize();
	} else {
		cout << "Corriendo optimizacion multiple:" << endl;
		for(int s=0; s<cantSeeds; s++){
			copiar(players[s], player);

			Optimize();
		}
	}

	cout << "Execution concluded" << endl;

	return 0;

}

