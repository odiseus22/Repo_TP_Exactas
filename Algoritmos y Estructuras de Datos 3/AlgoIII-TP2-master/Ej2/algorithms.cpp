/*
#include <iostream>
#include <queue>
#include <tuple>
#include <limits>
*/
#include "defines.h"
#include "auxiliar.cpp"
/*     -----     Algoritmos     -----     */
//Trabajo siempre con lista de adyacencias

/* -- Dijkstra -- */
vector<int> Dijkstra(graph& G, int v){
	//Pre: v pertenece a G
	vector<int> D(G.size(), none);D[v]=0;
	priority_queue<qElem> Q;
	for(auto x : edges(G[v])){
		Q.push(make_tuple(-costo(x),v,vecino(x)));
	}
	while(not Q.empty()){
		int c, v, w;
		tie(c,v,w) = Q.top();
		Q.pop();
		if(D[w] == none){
			D[w] = -c;
			for(auto x : edges(G[w])) if((D[vecino(x)]) == none)
				Q.push(make_tuple(c-costo(x), w, vecino(x)));
		}
	}
	return D;
}

/* -- Dijkstra con FIFO -- */
vector<int> Dijkstra_FIFO(graph& G, int v){
	//Pre: v pertenece a G
	vector<int> D(G.size(), inf);D[v]=0;
	queue<qElem> Q;
	for(auto x : edges(G[v])) Q.push(make_tuple(costo(x),v,vecino(x)));
	while(not Q.empty()){
		int c, v, w;
		tie(c,v,w) = Q.front();
		Q.pop();
		if(D[w] >= c){
			D[w] = c;
			for(auto x : edges(G[w]))
				Q.push(make_tuple(c+costo(x), w, vecino(x)));
		}
	}
	return D;
}


/* -- Bellman Ford -- */
//-- No tiene la verificacion de cambio por iteracion --
vector<int> BellmanFord(graph G, int v){
	//Pre: v pertenece a G
	vector<int> D(G.size(), inf); D[v]=0;
	for(int k=0; k<G.size()-1;k++) for(int w=0; w<=G.size()-1; w++){
		for(auto x: edges(G[w])) if(D[w] + costo(x) < D[vecino(x)]){
			D[vecino(x)] = D[w] + costo(x);
		}
	}
	return D;
}


/* -- Floyd Warshall -- */ 
// -- No verifica presencia de ciclos negativos (nunca los hay en nuestros problemas)--
matrix FloydWarshall(graph G){
	matrix D(G.size(), vector<int>(G.size(), inf));
	for(int v=0; v<G.size(); v++){
		D[v][v] = 0;
		for(auto e:edges(G[v])) D[v][vecino(e)] = costo(e);
	}
	for(int k=0;k<G.size();k++)
			for(int i=0; i<G.size(); i++){
				for(int j=0; j<G.size(); j++){
					if(D[i][j] > D[i][k] + D[k][j])
						D[i][j] = D[i][k] + D[k][j];
				}
			}
	return D;
}
