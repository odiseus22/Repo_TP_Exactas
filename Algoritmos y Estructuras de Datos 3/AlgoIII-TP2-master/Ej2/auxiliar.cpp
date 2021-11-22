/*
#include <iostream>
#include <vector>
#include <utility>
*/
#include "defines.h"

int& fuel(pair<vector<pair<int, int>>, int>& p){return get<1>(p);}
vector<pair<int, int>>& edges(pair<vector<pair<int, int>>, int>& p){
	return get<0>(p);
}

int costo(pair<int, int> p){return p.second;}
int vecino(pair<int, int> p){return p.first;}

/*
void printVector(vector<int>& v, int n){
	if(v.size()!=0){
		cout << "[";
		for(int i=0; i<n-1;i++){
			cout << v[i] << ",";
		}
		cout<<v[n-1]<<"]"<<endl;
	}
}
*/


void printVector(vector<int>& v, int n, int fila){
	for(int i = 0; i<n; i++){
		if(i != fila) {
			printf("%u %u %u \n", fila, i, v[i]);
		}
	}
}

void printGraph(graph& G,int n){
	for(int i=0;i<G.size();i++){
		cout << i%n << " (fuel=" << fuel(G[i]) <<")"<< " -> ";
		if(edges(G[i]).size()!=0){
			for(int j=0;j<edges(G[i]).size()-1;j++){
				cout << "(" << get<0>(edges(G[i])[j]) << "," << get<1>(edges(G[i])[j]) << "), ";
			}
			cout << "(" << get<0>(edges(G[i])[edges(G[i]).size()-1]) 
				 << "," << get<1>(edges(G[i])[edges(G[i]).size()-1]) 
				 << ")" << endl;
		} else {
			cout << "None" << endl;
		}
	}
}

void printMatrix(matrix& M, int n){
	for(int f=0;f<n;f++){
		printVector(M[f], n, f);
	}
}

graph takeInputEj2(int& n, int& m){
	cin >> n >> m;
	vector<int> C;
	for(int i=0; i<n; i++){
		int c;
		cin >> c;
		C.push_back(c);
	}
	for(int i=0;i<maxFuel;i++){
		for(int j=0;j<n;j++){
			C.push_back(C[j]);
		}
	}
	graph G((maxFuel+1)*n);
	for(int i=0;i<maxFuel+1;i++){
		int off = i*n;
		for(int j=0;j<n;j++){
			fuel(G[off+j]) = i;
		}
	}
	pair<int, int> p;
	int off;
	for(int i=0;i<m;i++){
		int v,w,l; cin >> v >> w >> l;
		for(int j=0; j<maxFuel+1;j++){
			off = n*j;
			for(int k=0;k<maxFuel+1;k++){
				int x = fuel(G[w+k*n])+l-fuel(G[off+v]);
				if(x>=0 && fuel(G[off+v])+x<=maxFuel){				
					p = make_pair(w+k*n,x*C[off+v]);
					edges(G[off+v]).push_back(p);	
				}
			}
		}
		for(int j=0; j<maxFuel+1;j++){
			off = n*j;
			for(int k=0;k<maxFuel+1;k++){
				int x = fuel(G[v+k*n])+l-fuel(G[off+w]);
				if(x>=0 && fuel(G[off+w])+x<=maxFuel){	
					p = make_pair(v+k*n,x*C[off+w]);
					edges(G[off+w]).push_back(p);
				}
			}
		}
	}
	return G;
}