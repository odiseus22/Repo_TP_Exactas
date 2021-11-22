#include <iostream>
#include <tuple>
#include <vector>
#include <algorithm>
#include <random>

using namespace std;

int INFINITO=100;

using ciudadesyrutas= tuple<  vector<tuple<int, int>> , vector<tuple<int,int,int>> >;

vector<tuple<int, int>>& getciudad(ciudadesyrutas& cyr){get<0>(cyr);}
vector<tuple<int,int,int>>& getrutas(ciudadesyrutas& cyr){get<1>(cyr);}


//n y m cantidad de ciudades y rutas, ciudadc y carreterasc cotas de su valor costo de recarga y largo de ruta (cotas superior)
//la cantidad de rutas es siempre el minimo entre m o  n*n-1/2
ciudadesyrutas generarinputrandom(int n, int m, int ciudadc, int carreterasc) {
    //n= rand() % n;
    // m= rand() % m;
    printf("%u %u\n", n, m);
    int i = 0;
    tuple<int, int> ciudad1;
    tuple<int, int> ciudad2;
    vector<tuple<int, int>> ciudades(n);                                                       //O(n)
    while (i < n) {  //genero ciudades y su costo de recargar combustible                        O(n)
        int recarga = (rand() % ciudadc) + 1;
        get<0>(ciudad1) = i;
        get<1>(ciudad1) = recarga;
        ciudades[i] = ciudad1;
        cout << recarga << endl;
        i++;
    }


    //genero n*(n-1)/2 valores para los pesos de las rutas  donde m cantidad de valores son distintos a infinito
    int j = 0;
    int aristascompleto = n * (n - 1) / 2;
    int rutapeso = INFINITO;
    vector<int> pesorutas(aristascompleto);                         ////O(n*n-1/2)
    while (j < aristascompleto) {                                   //O(n*n-1/2)
        if (j < m) {
            rutapeso = (rand() % carreterasc) + 1;
        } else {
            rutapeso = INFINITO;
        }
        pesorutas[j] = rutapeso;
        j++;
    }


    i = 0;
    j = 0;
    int r=0;
    vector<tuple<int,int,int>> rutas(m);                                         //O(m)
    while (i < ciudades.size()) {                                                //O(n.n) los 2 while
        j = i + 1;
        while (j < ciudades.size()) {
            //asingo ruta peso random a cada par de ciudades y la descarto de mi seleccion futura poniendola al final y borrando ese peso de ruta
            int k = rand() % pesorutas.size();
            int pesoauxiliar = pesorutas[k];
            pesorutas[k] = pesorutas[pesorutas.size() - 1];
            pesorutas.pop_back();

            //genero la ruta con origen y final, o no genero nada si la ruta tiene peso infinito

            if(pesoauxiliar==INFINITO){} else {
                ciudad1 = ciudades[i]; ciudad2 = ciudades[j];
                cout << get<0>(ciudad1) << " " << get<0>(ciudad2) << " " << pesoauxiliar << endl;
                tuple<int,int,int> guardoruta;
                get<0>(guardoruta)=get<0>(ciudad1);
                get<1>(guardoruta)=get<0>(ciudad2);
                get<2>(guardoruta)=pesoauxiliar;
                rutas[r]=guardoruta;
                r++;
            }

            j++;
        }
        i++;
    }

    ciudadesyrutas rta;
    getciudad(rta)=ciudades;
    getrutas(rta)=rutas;
    return rta;

}                                        //O(2n +2*((n*n-1)/2) + m + n.n) = O(n.n)
 



int main(int argc, char** argv) {
    if(argc < 3){
    //d es para testear  d cantidad de veces el algoritmo para generar input random
        int d=1;
        while(d>0){
            ciudadesyrutas debugeoreturn;
            debugeoreturn =generarinputrandom(4,3,60,60);  //devuelvo ciudades y caminos por si acaso ademas de darlos en un cout      O
            d--;
        }
        
    }else{
    	string s(argv[2]);
    	int cantidad_rutas = 0;
    	//Cantidad de ciudades
    	int cantidad_ciudades =  (int)(strtol(argv[1],NULL,10));
    	if(s == "random"){
	    	//asigno los parametros
	        //int cantidad_de_tests =  (int)(strtol(argv[1],NULL,10));
	        

	        //Codigo para generar cantidad de rutas
	        random_device rd;  //Will be used to obtain a seed for the random number engine
	        mt19937 gen(rd()); //Standard mersenne_twister_engine seeded with rd()
	        uniform_int_distribution<> distribution(cantidad_ciudades-1, (cantidad_ciudades*(cantidad_ciudades-1))/2);
	        cantidad_rutas = distribution(gen);
	       

	    } if(s == "completo"){
	    	cantidad_rutas = (cantidad_ciudades*(cantidad_ciudades-1))/2;


	    }
	    if(s == "ralo"){
	    	cantidad_rutas = cantidad_ciudades-1;
	    }

	    

	    generarinputrandom(cantidad_ciudades, cantidad_rutas, 60, 60 );
    }


    return 0;
}