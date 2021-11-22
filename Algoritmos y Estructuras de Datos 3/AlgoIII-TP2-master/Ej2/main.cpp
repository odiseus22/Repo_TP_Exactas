#include "algorithms.cpp"
#include <chrono>

using namespace std;

//Macro tiempo
#define medir_tiempo(K, CODIGO) \
    [&] () -> double {\
        double tiempo_promedio = 0.0;\
        for (int i = 0; i < K; ++i)\
        {\
            auto tiempo_inicio = chrono::steady_clock::now();\
            CODIGO \
            auto tiempo_fin = chrono::steady_clock::now();\
            tiempo_promedio += chrono::duration<double, milli>(tiempo_fin - tiempo_inicio).count();\
        }\
        return tiempo_promedio / (double)K;\
    }();


int REPETICIONES=25;



int main(int argc, char const * argv[]){
	if(argc <= 1){
		int n, m; graph G = takeInputEj2(n, m);

		//G es una lista de adyacencias con pares (vertice, distancia)
		
		//Solves with Dkikstra P_Q
		cerr << "Solucion con Dijkstra con priority_queue" << endl << endl;
		for(int i=0;i<n;i++){
			vector<int> D = Dijkstra(G, i);
			printVector(D, n, i);
		}

		cout << endl << endl;

		//Solves with Dkikstra FIFO
		cerr << "Solucion con Dijkstra con FIFO" << endl << endl;
		for(int i=0;i<n;i++){
			vector<int> D = Dijkstra_FIFO(G, i);
			printVector(D, n, i);
		}

		cout << endl << endl;

		//Solves with Bellman-Ford
		cerr << "Solucion con Bellman-Ford" << endl << endl;
		for(int i=0;i<n;i++){
			vector<int> D = BellmanFord(G, i);
			printVector(D, n, i);

		}

		cout << endl << endl;

		//Solves with Floyd-Warshall
		cerr << "Solucion con Floyd-Warshall" << endl << endl;
		matrix M = FloydWarshall(G);
		printMatrix(M, n);

		cout << endl << endl;
	} else{
		//Codigo Tests
		int n, m;
		graph G = takeInputEj2(n,m);	
		double tiempo;

		string s(argv[1]);

		if(s == "Dijkstra"){
			cerr << "Solucion con Dijkstra con priority_queue" << endl;
			tiempo = medir_tiempo(REPETICIONES,Dijkstra(G,i););
		}
		if(s == "Dijkstra_FIFO"){
			cerr << "Solucion con Dijkstra con FIFO" << endl;
			tiempo = medir_tiempo(REPETICIONES,Dijkstra_FIFO(G, i););
		}

		if(s == "Bellman-Ford"){
			cerr << "Solucion con Bellman-Ford" << endl;
			tiempo = medir_tiempo(REPETICIONES,BellmanFord(G,i););
		}
		if(s == "Floyd-Warshall"){
			cerr << "Solucion con Floyd-Warshall" << endl;
			tiempo = medir_tiempo(REPETICIONES,FloydWarshall(G););
		}

		printf("%u; %u; %f \n", n, m, tiempo);
		
	}

	return 0;
}
