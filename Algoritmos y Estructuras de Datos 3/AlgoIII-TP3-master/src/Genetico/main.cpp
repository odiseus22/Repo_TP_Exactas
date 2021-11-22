
#include "juez.h"
#include "mutar.h"


int ITER = 100;
float PARTIDAS = 100;
float WINRATE = 0.99;
int fitness_type = 3;
int ganadas_totales = 0;
int jugadas_totales = 0;

//Jugador random
vector<int> random_player = {RANDOM};
vector<float> puntaje;


void fitness(vector<int> &cant_jugadas, vector<int> &ganadas, vector<float> &puntajes){
	for(int i = 0; i < cant_jugadas.size(); i++){
		if(fitness_type == 1){
			puntajes.push_back((float)ganadas[i]/ganadas_totales);
		}else if(fitness_type == 2){
			puntajes.push_back(1-(cant_jugadas[i]/(float)jugadas_totales));
		}else{
			//Caso 3
			puntajes.push_back(((float)ganadas[i]/ganadas_totales +  1 - cant_jugadas[i]/(float)jugadas_totales)/2);
		}
	}
}

void jugar(vector<int> &individuo, vector<int> &ganadas, vector<int> &jugadas, int m, int n, int c, int p){
	int gana = 0;
	int movimientos = 0;
	for(int j = 0; j < (PARTIDAS/2); j++){
		
		result res1=juez(m,n,c,p,individuo,random_player);
		result res2=juez(m,n,c,p,random_player,individuo);
		if(res1.ganador == 1){
			gana++;
		}
		movimientos += res1.cant_jugadas;

		if(res2.ganador == 2){
			gana++;
		}
		movimientos += res2.cant_jugadas;
	}

	ganadas.push_back(gana);
	jugadas.push_back(movimientos);
	ganadas_totales = ganadas_totales + gana;
	jugadas_totales= jugadas_totales + movimientos;
	


}



int main(int argc, char *argv[]){
	

	if(argc < 2){
		cout << "Formato correcto: ./main <cantidad de iteraciones> <fitness type>  " << endl;
		cout << "fitness type puede ser 1 2 or 3" << endl;
		cout << "fitness type= 1: en base a cantidad de ganadas" << endl;
		cout << "fitness type= 2: en base a cantidad de jugadas" << endl;
		cout << "fitness type= 2: en base a cantidad de jugadas y cantidad de jugadas" << endl;
		cout << "sin estos parametros el programa sera con 100 iteraciones y fitness = 3" << endl;
	}else{
		ITER = stoi(argv[1]);
		fitness_type =stoi(argv[2]);
	}


	
	//Tablero 4 en linea
	int n = 7; 
	int m = 6;
	int p = 21;
	int c = 4;

	//Vectores para guardar informaciond de fitness
	vector<int> cant_jugadas;
	vector<int> ganadas;



	//Poblacion inicial
	vector< vector<int> > poblacion = {
		{1,5000,5000,100,100},
		{1,5000,5000,5000,100},
		{1,5000,5000,100,5000},
		{1,5000,5000,5000,5000},
		{1,5000,100,100,100},
		{1,5000,100,5000,100},
		{1,5000,100,100,5000},
		{1,5000,100,5000,5000},
		{1,100,5000,100,100},
		{1,100,5000,5000,100},
		{1,100,5000,100,5000},
		{1,100,5000,5000,5000},
		{1,100,100,100,100},
		{1,100,100,5000,100},
		{1,100,100,100,5000},
		{1,100,100,5000,5000},	 
	
	};

	vector<int> mejores_genes = {0};
	int mas_ganadas = 0;


	//Calculo fitness poblacion inicial
	for(int i = 0; i<poblacion.size(); i++){
		jugar(poblacion[i], ganadas, cant_jugadas,m ,n,c,p);
		if(mas_ganadas <= ganadas[i]){
			mas_ganadas = ganadas[i];
			mejores_genes = poblacion[i];
		}
	}
	fitness(cant_jugadas, ganadas, puntaje);


	

	//Para al llegar a las 100 iteraciones o al llegar a uno que tiene 100% win rate
	for(int iteraciones = 0; iteraciones < ITER && ((float)mas_ganadas/PARTIDAS) < WINRATE; iteraciones++){

		//generar nueva generacion
		
		vector<vector<int>> nueva_generacion;
		vector<int> nuevas_jugadas;
		vector<int> nuevas_ganadas;
		vector<float> nuevo_puntaje;

		//Seleccion
		vector<int> elegidos1 = seleccion_ponderada(puntaje);
		vector<int> elegidos2 = seleccion_random(poblacion);
		/*cout << elegidos1.size() << endl;
		for(int i = 0; i < elegidos1.size(); i++){
			cout << elegidos1[i] << "   "<< elegidos2[i] << endl;

		}
		*/

		int mejor_generacion_actual = -1;
		jugadas_totales = 0;
		ganadas_totales = 0;
		for(int i = 0; i < elegidos1.size(); i++){
			
			
			//Seleccion ponderada
			int seleccionado1 = elegidos1[i];

			//Seleccion competencia
			int seleccionado2 = elegidos2[i];

			
			//Crossover
			hijos h = crossover(poblacion[seleccionado1], poblacion[seleccionado2]);
						

			
			//Mutacion con prob definida en mutar.h
			mutar(h.hijo1);
			mutar(h.hijo2);

			//Juegan para calcular parametros del fitness
			jugar(h.hijo1, nuevas_ganadas, nuevas_jugadas,m ,n,c,p);
			jugar(h.hijo2, nuevas_ganadas, nuevas_jugadas,m ,n,c,p);

			
			

			if(mas_ganadas <= nuevas_ganadas[2*i]){
				mas_ganadas = nuevas_ganadas[2*i];
				mejores_genes = h.hijo1;
			}
			if(mas_ganadas <= nuevas_ganadas[2*i-1]){
				mas_ganadas = nuevas_ganadas[2*i-1];
				mejores_genes = h.hijo2;
			}

			//Para ver la evolucion:
			if(mejor_generacion_actual <= nuevas_ganadas[2*i]){
				mejor_generacion_actual = nuevas_ganadas[2*i];
			}
			if(mejor_generacion_actual <= nuevas_ganadas[2*i-1]){
				mejor_generacion_actual = nuevas_ganadas[2*i-1];
			}



			//Agregar a un vector temporal
			nueva_generacion.push_back(h.hijo1);
			nueva_generacion.push_back(h.hijo2);


		}
		fitness(nuevas_jugadas, nuevas_ganadas, nuevo_puntaje);

		
		
		//reemplazo al vector de genes los nuevos resultados
		copy(nueva_generacion.begin(), nueva_generacion.end(), poblacion.begin());
		copy(nuevas_jugadas.begin(),nuevas_jugadas.end(), cant_jugadas.begin());
		copy(nuevas_ganadas.begin(),nuevas_ganadas.end(), ganadas.begin());
		copy(nuevo_puntaje.begin(), nuevo_puntaje.end(), puntaje.begin());

		//Limpio los vectores para la siguiente generacion
		nuevas_ganadas.clear();
		nuevas_ganadas.clear();
		nueva_generacion.clear();
		nuevo_puntaje.clear();
		//cout << "iteracion: " << iteraciones << endl;
		//cout << "mejor WINRATE generacion: " << (float)mejor_generacion_actual/PARTIDAS << endl;
		//cout << "mejor WINRATE: " << (float)mas_ganadas/PARTIDAS << endl;

	}

	//Escribir el mejor individuo
	//cout<< " Cantidad de ganadas: " << mas_ganadas<< endl;
	//cout << "genes: ";
	for(int i = 1; i < mejores_genes.size(); i++){
		cout << mejores_genes[i]<< " ";

	}
	cout << endl;

	//Escribir la ultima generacion
	



	return 0;

}

