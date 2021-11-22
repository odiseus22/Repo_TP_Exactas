#include "mutar.h"


uniform_real_distribution<> dis(0.0, 1.0);



//Muta los genes de un jugador al azar, 50 % de sumar y 50% de restar, un porcentaje.
void mutar(vector<int> &genes){
		
	//random
	random_device rd;
	mt19937 generator(rd());
	
	double r;
	//Itero en cada gen
	for(int i = 1; i < 5;i++){
		r = dis(rd);

		if(r <= MUTACION){
			r = dis(rd);
			if(r<= 0.5){
				r = dis(rd);
				genes[i] += genes[i]*r*2; 
			}else{
				r = dis(rd);
				genes[i] -= genes[i]*r*2;
			}
			
		}
	}

	
	
}

//Devuelvo la nueva generacion en gen1 y gen2
//50% de probabilidad de intercambiar para gen
hijos crossover(vector<int> gen1, vector<int>  gen2){
	//random
	random_device rd;
	mt19937 generator(rd());


	
	double r;
	int aux;
	for(int i = 1; i < gen1.size(); i++){
		r = dis(rd);
		if(r <= 0.5){
			aux = gen1[i];
			gen1[i] = gen2[i];
			gen2[i] = aux;
		}
	}
	
	hijos h;
	h.hijo1 = gen1;
	h.hijo2 = gen2;

	return h;
}

vector<int> seleccion_ponderada(vector<float> &puntajes){
	random_device rd;
	mt19937 generator(rd());

	vector<int> res;

	for(int i = 0; i < (puntajes.size()/2); i++){
		//agrego cuales fueron seleccionados usando la probabilidad
		float f = dis(rd);
		

		float aux = 0;
		
		bool agrege = false;
		for(int j = 0; j < puntajes.size(); j++){

			aux+= puntajes[j];
			
			if(aux >= f){
				res.push_back(j);
				agrege = true;
				break;
			}

		}
		//Caso a parte por si el redondeo al dividir float da menos de 2 
		if(!agrege){
			res.push_back(puntajes.size()-1);
		}

	}	

	return res;

}


vector<int> seleccion_random(vector<vector<int> > &poblacion){
	//random
	random_device rd;
	mt19937 generator(rd());
	vector<int> res;
	for(int i = 0; i < poblacion.size()/2; i++){
		float valor_random = dis(rd);

		int individuo = valor_random*poblacion.size();	 
		res.push_back(individuo);
		
	}
	return res;


}


