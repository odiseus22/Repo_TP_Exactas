#include <iostream>
#include <vector>
#include <tuple>
#include <list>
#include <chrono>
#include <cstdio>

using namespace std;

//fuerza bruta

list<tuple<int,int>> valorespartes(list<tuple<int,int>> lin, tuple<int,int> elemto){ // esto hace ejemplo (1,2) 4 -> (1,1+4,2,2+4) (pero en ves de ints son tuplas int,int)
    list<tuple<int,int>> res;                                                        // son tuplas con las sumas de cada elemento del subconjunto de partes O(n)
    while(!lin.empty()){                                                             //O(n) lin.size=n
        tuple<int, int> temporal;
        get<0>(temporal) = get<0>(lin.front());
        get<1>(temporal) = get<1>(lin.front());
        res.push_back(temporal); //agrego sin suma
        get<0>(temporal) += get<0>(elemto);
        get<1>(temporal) += get<1>(elemto);
        res.push_back(temporal); //agrego con suma
        lin.pop_front();
    }
    return res;
}

list<tuple<int,int>> sumaspartes(list<tuple<int,int>> vin ){
    if(vin.empty()){
        tuple<int,int> tplcero;
        get<0>(tplcero)=0;
        get<1>(tplcero)=0;
        list<tuple<int,int>> listaconcero;
        listaconcero.push_back(tplcero);
        return listaconcero;
    }else{
        tuple<int,int> primero=vin.front();
        list<tuple<int,int>> sinprimero = vin;
        sinprimero.pop_front();
        return valorespartes(sumaspartes(sinprimero),primero); // ((0)) 1-> ((0,1),(0))2 -> ( (0,1),(0),(0,1,2),(0,2) )
    }                                                          // O(n. cantidad de recursiones) n=2^m m=vin.size=cantidad de recurciones=m -> O(m.2^m)
}

tuple<int,int> elijooptima(list<tuple<int,int>> vin, int cotapeso){
    tuple<int,int> res;
    get<0>(res)=0;
    get<1>(res)=0;
    while(!vin.empty()){
        if(get<0>(vin.front()) <= cotapeso && get<1>(vin.front()) > get<1>(res)){
            res = vin.front();
        }
        vin.pop_front();
    }
    return res;
}





tuple < int, list<tuple<int,int>>> lectoratxt(){ //O(n)  lee imput del trabajo practico
    cerr << "insertar n cantidad de elementos y c cota de peso de mochila maximo " << endl;
    int n;
    int c;
    cin >> n >> c ;
    cerr << "insertar w tamano y p valor " << endl;
    list<tuple<int,int>> rta;
    tuple< int, list<tuple<int,int>>> tuplerta;
    get<0>(tuplerta)=c;
    int w;
    int p;
    tuple<int,int> wp (w,p);
    int i =0;
    while(i!=n){
        cin >> w >> p;
        get<0>(wp)=w;
        get<1>(wp)=p;
        rta.push_back(wp);
        i++;
    }
    cerr << "calculando, esto podria tardar un rato" << endl;
    get<1>(tuplerta)=rta;
    return tuplerta;
}

tuple<int,int> hacerfuerzabruta(tuple<int,list<tuple<int,int>>> inputlectora,int k,bool entrega){
    tuple<int,int> ganador;
    int cotapeso=get<0>(inputlectora);
    list<tuple<int,int>> &listainput=get<1>(inputlectora);
    double tiempo_promedio = 0.0;
    int repetir=k;
    while(repetir>0) {
        auto tiempo_inicio = chrono::steady_clock::now();
        list<tuple<int, int>> partesdeinput = sumaspartes(listainput);
        ganador = elijooptima(partesdeinput, cotapeso);
        auto tiempo_fin = chrono::steady_clock::now();
        tiempo_promedio += chrono::duration<double, milli>(tiempo_fin - tiempo_inicio).count();
        repetir--;
    }
    tiempo_promedio /= (double)k;
    int p =get<1>(ganador);
    int n=get<1>(inputlectora).size();
    if(entrega){
        cout << p << endl;
    } else {
        cout << n << "," << get<0>(inputlectora) << "," << tiempo_promedio << "," << p << endl;
    }
    return ganador;
}

//meet in the middle

list<list<tuple<int,int>>> armomitades(list<tuple<int,int>> listentrada){//separo 1 lista en 2 listas    O(n)
    list<list<tuple<int,int>>> las2listas;
    list<tuple<int,int>> list1;
    list<tuple<int,int>> list2;
    int medio=listentrada.size()/2;
    while(!listentrada.empty()){                                         //armo 2 listas
        if(listentrada.size()>medio ){
            list1.push_back(listentrada.front());
        } else{
            list2.push_back(listentrada.front());
        }
        listentrada.pop_front();
    }
    las2listas.push_back(list1);
    las2listas.push_back(list2);
    return las2listas;
}                                                                        //post: 2 listas (en una lista) que concatenadas te dan la lista del input


list<tuple<int,int>> merge(list<tuple<int,int>> l1ord, list<tuple<int,int>> l2ord ){//lista pre:1 ordenada y lista 2 ordenada  O(n+m)
    list<tuple<int,int>> listmerge;
    int i=l1ord.size()+l2ord.size();
    while(i>0){

        if( (!l1ord.empty()) && (!l2ord.empty()) ){
            if( get<0>(l1ord.front()) <= get<0>(l2ord.front())){
                listmerge.push_back(l1ord.front());
                l1ord.pop_front();
            } else{
                listmerge.push_back(l2ord.front());
                l2ord.pop_front();
            }
        }else{
            if(l1ord.empty()){
                listmerge.push_back(l2ord.front());
                l2ord.pop_front();
            }else{
                listmerge.push_back(l1ord.front());
                l1ord.pop_front();
            }
        }
        i--;

    }
    return listmerge;
}                                                                      //post 1 lista ordenada que tiene los elementos de las 2 listas originales(ordenadas)


list<tuple<int,int>> mergesort(list<tuple<int,int>> const & desordenado){//O(nlogn) ORDENA POR PESO MENOR A MAYOR

    if(desordenado.size() <= 2) { //caso base
        list<tuple<int,int>> ordenado;
        if (desordenado.size() == 2) {
            if(get<0>(desordenado.front()) <= get<0>(desordenado.back())){
                ordenado=desordenado;
            }else {
                ordenado.push_back(desordenado.back());
                ordenado.push_back(desordenado.front());
            }
        }else{
            ordenado=desordenado;
        }
        return ordenado;
    }else{                     //caso recursivo
        list<list<tuple<int,int>>> susmitades=armomitades(desordenado);
        return merge(mergesort(susmitades.front()),mergesort(susmitades.back()));

    }
}


vector<tuple<int,int>> sacoinutiles(list<tuple<int,int>> &sininutiles){// pre: tengo una lista que es las sumas de cada elemento del conjunto de partes y esta ordenado de almenos tamaño 1 (elmento (0,0)
    vector<tuple<int,int>> vectorout;                                  // es O(n)
    if(sininutiles.size()==1){                                         // lo paso t0do a vector porque desp necesito hacer busqueda binaria! (quedo raro porque me di cuenta tarde)
        vectorout.push_back(sininutiles.front());
    } else {
        while (sininutiles.size() > 1) {
            auto it2 = sininutiles.begin();
            it2++;
            if (get<1>(sininutiles.front()) >= get<1>(*(it2))) {       //si tengo alguien mas igual pesado y no es mas valioso lo saco de la lista
                sininutiles.erase(it2);
                if (sininutiles.size() == 1) {
                    vectorout.push_back(sininutiles.front());
                }
            } else {                                                   //sino lo agrego
                if (get<0>(sininutiles.front()) == get<0>(*(it2))) {   //(0,1) (0,2)-> (0,2)
                    sininutiles.pop_front();
                } else {                                               //(1,1)(2,2) ->(1,1)(2,2)
                    vectorout.push_back(sininutiles.front());
                    sininutiles.pop_front();
                    if (sininutiles.size() == 1) {
                        vectorout.push_back(sininutiles.front());
                    }
                }
            }

        }
    }


    return vectorout;
}                                                                      //post condicion un vector de tupla ordenados por peso y valor de menor a mayor  y queda un unico elemento de mismo peso
                                                                       // queda solamente los elementos relevantes

//busqueda binaria para parejas  busco en partes de b ((b.size=2^n/2) n=cant de tuplas de imput ) la pareja de un elemento
tuple<int,int> buscarparejaa(tuple<int,int> const &soltero, vector<tuple<int,int>> const &candidatos, int const & cotapeso){ //busquedabinaria O(log n) n=candidatos.size
    tuple<int,int> pareja;                                                                                                   //pre: elementos ordenados por peso y ganancia (menor a mayor)
    int i1=0;
    int i2=candidatos.size()-1;
    int pesopermitido = cotapeso - get<0>(soltero);
    if(pesopermitido<=0){
       pareja=candidatos[0];           //la pareja es no agregarle valor ni peso
    } else {
        while (abs(i1 - i2) > 1) {
            int imedio=i1+((i2-i1)/2);
            if ( get<0>(candidatos[imedio]) > pesopermitido ) {
                i2=imedio;
            } else{
                i1=imedio;
            }
        }
        if( get<0>(candidatos[i2])<= pesopermitido ){ //caso cuando no entro al while
            pareja=candidatos[i2];
        } else{
            pareja=candidatos[i1];
        }
    }
    return pareja;
}


//armo la mejor pareja (la que suma mas valor, y no pasa cotapeso) para cada elemento de a
 list<tuple<int,int>> mejorespares(list<tuple<int,int>> const & p1, vector<tuple<int,int>> const &p2, int cotapeso){
    list<tuple<int,int>> rtav;
    auto it=p1.begin();
    while(it!=p1.end()){
        tuple<int,int> eleccion;
        tuple<int,int> candidato;
        candidato=buscarparejaa(*it,p2,cotapeso);
        get<0>(eleccion)=get<0>(candidato)+get<0>(*it);
        get<1>(eleccion)=get<1>(candidato)+get<1>(*it);
        rtav.push_back(eleccion);
        it++;
    }
    return rtav;
}


//busco el ganador( una ves ya hechas las parejas)


tuple<int,int> resuelvomitades(list<list<tuple<int,int>>>& las2mitades, int cotapeso){
    list<tuple<int,int>> &list1=las2mitades.front();
    list<tuple<int,int>> &list2=las2mitades.back();
    list<tuple<int,int>> parteslist1;
    list<tuple<int,int>> parteslist2;
    vector<tuple<int,int>> partesvector2;
    tuple<int,int> ganador;
    parteslist1=sumaspartes(list1);
    parteslist2=sumaspartes(list2);
    parteslist2=mergesort(parteslist2);
    partesvector2=sacoinutiles(parteslist2);
    parteslist2=mejorespares(parteslist1,partesvector2,cotapeso);  //elijo si agarro de p1 de p2 o la concatenacion
    ganador =elijooptima(parteslist2,cotapeso);                   //busqueda lineal en la estructura anterior
    return ganador;
}

tuple<int,int> hacermeetinmiddle(tuple<int,list<tuple<int,int>>> const & inputlectora,int k,bool entrega){  //uso todas las funciones para hacer meetintemidle ecepto el codigo de leer imput
    tuple<int,int> ganador;
    int cotapeso=get<0>(inputlectora);
    list<tuple<int,int>> const& listainput=get<1>(inputlectora);
    int repetir=k;
    double tiempo_promedio = 0.0;
    while(repetir>0) {
        auto tiempo_inicio = chrono::steady_clock::now();
        list<list<tuple<int, int>>> lasmitades = armomitades(listainput);
        ganador = resuelvomitades(lasmitades, cotapeso);
        auto tiempo_fin = chrono::steady_clock::now();
        tiempo_promedio += chrono::duration<double, milli>(tiempo_fin - tiempo_inicio).count();
        repetir--;
    }
    tiempo_promedio /= (double)k;
    get<0>(inputlectora); //peso
    int p=get<1>(ganador);
    int n=get<1>(inputlectora).size();
    if(entrega){
        cout << p << endl;
    } else {
        cout << n << "," << get<0>(inputlectora) << "," << tiempo_promedio << "," << p << endl;
    }
    return ganador;
}

//back tracking



int gananciatotal(list<tuple<int,int>> const& listin){ // calculo ganancia sumada de todos los elementos de la lista de imput
    int gananciaacumulada=0;                           //O(n)
    auto it=listin.begin();
    while(it!=listin.end()){                           //n iteraciones con O(1)
        gananciaacumulada=gananciaacumulada+get<1>(*it);
        it++;
    }
    return gananciaacumulada;
}

void soynuevoganador(tuple<int,int,int> &actualganador, tuple<int,int,int> const & candidato, int const &cotapeso){
    if ( ( get<0>(candidato)<=cotapeso ) && ( get<1>(actualganador) <= get<1>(candidato) ) ){
        actualganador=candidato;
    }
}


tuple<list<tuple<int,int,int>>,tuple<int,int,int>> valorespartes2(tuple<list<tuple<int,int,int>>,tuple<int,int,int>> infoin, tuple<int,int,int> elemto,  int cotapeso){ // esto hace ejemplo (1,2) 4 -> (1,1+4,2,2+4) (pero en ves de ints son tuplas int,int)
    list<tuple<int,int,int>> res;                                                                 // son tuplas con las sumas de cada elemento del subconjunto de partes O(n)
    tuple<list<tuple<int,int,int>>,tuple<int,int,int>> resyganador;
    tuple<int,int,int> ganadorviejo;        //tupla<peso,ganancia,ganancianocomputada>
    ganadorviejo=get<1>(infoin);
    list<tuple<int,int,int>>  & lin= get<0>(infoin);
    while(!lin.empty()){                                                                          //O(n) lin.size=n
        tuple<int,int,int> temporal;
        tuple<int,int,int> temporalagregado;
        get<0>(temporal) = get<0>(lin.front());
        get<1>(temporal) = get<1>(lin.front());
        get<2>(temporal) = get<2>(lin.front());
        get<2>(temporal) = get<2>(temporal) - get<1>(elemto);
        get<0>(temporalagregado) = get<0>(temporal)+ get<0>(elemto);
        get<1>(temporalagregado) = get<1>(temporal)+ get<1>(elemto);
        get<2>(temporalagregado)=get<2>(temporal);
        if(get<2>(temporal)<0){//borrar
            get<2>(temporal)=0;//borrar
        }
        res.push_back(temporal); //agrego sin suma
        if(get<0>(temporalagregado)>cotapeso || get<1>(temporalagregado)+get<2>(temporalagregado)<get<1>(ganadorviejo)){//si agregar el elemento no va a ser mejor q mi candidato o es muy pesado no lo agrego
        } else{
            soynuevoganador(ganadorviejo,temporalagregado,cotapeso);
            res.push_back(temporalagregado); //agrego con suma
        }
        lin.pop_front();//variables para elegir outputs!
    }
    get<0>(resyganador)=res;
    get<1>(resyganador)=ganadorviejo;
    return resyganador;
}

//                             tupla<peso,ganancia,ganancianocomputada>
tuple<list<tuple<int,int,int>>,tuple<int,int,int>> sumaspartes2(tuple<list<tuple<int,int,int>>,tuple<int,int,int>> infoin, int cotapeso){
    tuple<list<tuple<int,int,int>>,tuple<int,int,int>> infout;
    list<tuple<int,int,int>>  vin=get<0>(infoin);//variables para elegir outputs
    if(vin.empty()){  //caso base genero elemento <0,0,gananciatotaldisponible> caso base, cada elemento guarda en su 3er componente cuanto le falta computar
        tuple<int,int,int> tuplcongananciatotal;
        tuplcongananciatotal=get<1>(infoin);
        tuple<int,int,int> tplcero;
        get<0>(tplcero)=0;
        get<1>(tplcero)=0;
        get<2>(tplcero)=get<2>(tuplcongananciatotal);
        list<tuple<int,int,int>> listaconcero;
        listaconcero.push_back(tplcero);
        get<0>(infout)=listaconcero;
        get<1>(infout)=tplcero;
        return infout;
    }else{
        tuple<int,int,int> primero=vin.front();
        list<tuple<int,int,int>> sinprimero = vin;
        sinprimero.pop_front();
        get<0>(infout)=sinprimero;
        get<1>(infout)=get<1>(infoin);
        return valorespartes2(sumaspartes2(infout,cotapeso),primero,cotapeso); // ((0)) 1-> ((0,1),(0))2 -> ( (0,1),(0),(0,1,2),(0,2) )
    }                                                            // O(n. cantidad de recursiones) n=2^m m=vin.size=cantidad de recurciones=m -> O(m.2^m)
}



tuple<int,int,int> hacerbacktracking(tuple < int, list<tuple<int,int>>> const & infoin,int k, bool entrega){
    int cotapeso = get<0>(infoin);
    tuple<int,int,int> rta;
    tuple<int,int,int> nulo;
    list<tuple<int,int>> const & listin=get<1>(infoin);
    int gananciadisponible =gananciatotal(listin);
    auto it = listin.begin();
    tuple<list<tuple<int,int,int>>,tuple<int,int,int>> infobacktrack;
    tuple<list<tuple<int,int,int>>,tuple<int,int,int>> outbactrack;
    list<tuple<int,int,int>> listbactrack;
    while(it!=listin.end()){ //adapto el tamaño de la tupla del input generico a un input donde guardo la ganancia acumulada
        tuple<int,int,int> temporal;
        get<0>(temporal)=get<0>(*it);
        get<1>(temporal)=get<1>(*it);
        get<2>(temporal)=gananciadisponible;//-1 significa no hice ningun computo de ganancia restante aun
        listbactrack.push_back(temporal);
        it++;
    }
    get<0>(infobacktrack)=listbactrack;
    get<0>(nulo)=0;
    get<1>(nulo)=0;
    get<2>(nulo)=gananciadisponible;
    get<1>(infobacktrack)=nulo;
    int p=0;
    int repetir=k;
    double tiempo_promedio = 0.0;
    while(repetir>0) {
        auto tiempo_inicio = chrono::steady_clock::now();
        outbactrack = sumaspartes2(infobacktrack, cotapeso);
        auto tiempo_fin = chrono::steady_clock::now();
        rta = get<1>(outbactrack);
        p = get<1>(rta);
        tiempo_promedio += chrono::duration<double, milli>(tiempo_fin - tiempo_inicio).count();
        repetir--;
    }
    tiempo_promedio /= (double)k;
    int n=get<1>(infoin).size();
    if(entrega){
        cout << p << endl;
    } else {
        cout << n << "," << get<0>(infoin) << "," << tiempo_promedio << "," << p << endl;
    }
    return  rta;
}


//Programación dinámica

//adaptador lectora
vector<tuple<int,int>> adaptadoravector(tuple < int, list<tuple<int,int>>> const& textin){ //O(n)  lee imput del trabajo practico
    list<tuple<int,int>> const & listin=get<1>(textin);
    vector<tuple<int,int>> vectout;
    auto it=listin.begin();
    while(it!=listin.end()){
        vectout.push_back(*it);
        it++;
    }
    return vectout;
}


//Solución bottom-up (aprovechar subproblemas)

tuple<int, int> matrizKnapsack(vector<tuple<int,int>> elementos, int cotaPeso){  //O(n.W)
    //Matriz que bottom up va guardando toda la recursión.
    //quiero una fila para cada item y una columna para cada peso
    int n = elementos.size();
    vector<vector<int>> matrizDinamica(cotaPeso+1,vector<int>(n+1)); // debería medir w*n

    for(int po=0; po<n+1; po++){
        (matrizDinamica[0])[po]=0;
    }

    tuple<int, int> res;
    get<0>(res) = 0;
    for(int i = 1; i< n+1; i++){
        for(int w = i; w < cotaPeso+1; w++){
            if(w == 0 || i == 0){
                matrizDinamica[w][i] = 0;
            }else if(get<0>(elementos[i-1]) <= w){
                int conPrimero =get<1>(elementos[i-1]) + (matrizDinamica[w - get<0>(elementos[i-1])])[i-1];
                int sinPrimero = matrizDinamica[w][i-1];
                if(conPrimero < sinPrimero){
                    matrizDinamica[w][i] = sinPrimero;
                } else {
                    matrizDinamica[w][i] = conPrimero;
                    get<0>(res) += get<0>(elementos[i-1]);
                }
            } else {
                (matrizDinamica[w])[i] = (matrizDinamica[w])[i-1];
            }
        }
    }
    get<1>(res) = matrizDinamica[cotaPeso][n];
    return res;
}

tuple<int,int> hacerprogdinamica(tuple < int, list<tuple<int,int>>> textin,int k, bool entrega){
    int cotapeso =get<0>(textin);
    tuple<int,int> rta;
    vector<tuple<int,int>> vectin;
    vectin=adaptadoravector(textin);
    int p=0;
    double tiempo_promedio = 0.0;
    int repetir=k;
    while(repetir>0) {
        auto tiempo_inicio = chrono::steady_clock::now();
        rta = matrizKnapsack(vectin, cotapeso);
        auto tiempo_fin = chrono::steady_clock::now();
        p = get<1>(rta);
        tiempo_promedio += chrono::duration<double, milli>(tiempo_fin - tiempo_inicio).count();
        repetir--;
    }
    tiempo_promedio /= (double)k;
    int n=get<1>(textin).size();
    if(entrega){
        cout << p << endl;
    } else {
        cout << n << "," << get<0>(textin) << "," << tiempo_promedio << "," << p << endl;
    }
    return rta;
}

//auxiliares de experimentacion

tuple<int, list<tuple<int, int>>> primerosn(int n, tuple<int, list<tuple<int, int>>> const & inputlectora){
    tuple<int, list<tuple<int, int>>> rta;
    list<tuple<int, int>> seleccionados;
    int inputsize=get<1>(inputlectora).size();
    int i =inputsize-n;
    seleccionados =get<1>(inputlectora);
    while(i>0){
        seleccionados.pop_back();
        i--;
    }
    get<0>(rta)=get<0>(inputlectora);
    get<1>(rta)=seleccionados;
    return rta;
}


int main() {
  //  cerr << "escribir el numero entre parentesis del algoritmo a utilizar" << endl;
  //  cerr << "fuerzabruta(0), meet in the middle(1), backtrack(2), programacion dinamica(3)" << endl;
  //  int cual;
  //  cin >> cual;


    //variables para elegir outputs!
    bool entrega= true; //el output coincide con el formato de output del tp si entrega=1 sino coincidie con el formato de experimentacion
    int k = 25; //k es la cantidad de veces que voy a testear para sacar promedio
    //VARIABLES EXPERIMENTACION
    bool individual = false; //si es 1 pruebo con 1 solo input, sino pruebo con el los sub inputs (la lista del input con 1 elemento, con 2, desp con 3 etc..)
    //individual es para experimentacion!!!
    bool NoW =true; //si es true varia n si es false varia peso
    bool NyW=true; //Incremento AMBAS!
    int variacionW=-500; //cuanto varia el peso en cada paso
    int cual=0; //cual algoritmo me hago  fbruta=0, meetinthemiddle=1; backtracking=2, progdinamica=3 (solo tiene sentido si individual=false) -1 hago todos
    int hasta=4; //permite hacer desde variable cual, hasta la variable hasta sin incluir



    //crea lista de tuplas con imput de consola
    tuple<int, list<tuple<int, int>>> testlectoracncota;
    testlectoracncota = lectoratxt();


    if(entrega==true) {
        hasta = cual + 1;
    }
    while(cual<hasta) {
        if (entrega == false) {
            //freopen("TEST1","r",stdin);
            freopen("OutDebug.txt", "w", stdout);
            if (cual == 0) {
                freopen("OutFB.txt", "w", stdout);
            }
            if (cual == 1) {
                freopen("OutMEET.txt", "w", stdout);
            }
            if (cual == 2) {
                freopen("OutBACKTRK.txt", "w", stdout);
            }
            if (cual == 3) {
                freopen("OutDINAMIC.txt", "w", stdout);
            }

            cout << "n,peso,tiempopromedio(ms),ganancia maxima" << endl;
        } else {
            individual = true;
        }

        if (individual == false) {
            int cotapesov=get<0>(testlectoracncota);
            int n = (get<1>(testlectoracncota)).size();
            int i = 1;
            while (i != n + 1) {
                tuple<int, list<tuple<int, int>>> inputparalagoritmos;
                if(NyW){
                    inputparalagoritmos = primerosn(i, testlectoracncota);
                    get<0>(inputparalagoritmos) = cotapesov;
                    cotapesov = cotapesov + variacionW;
                } else {
                    if (NoW) { //PARA VARIAR N
                        inputparalagoritmos = primerosn(i, testlectoracncota);
                    } else { //para variar peso
                        inputparalagoritmos = testlectoracncota;
                        get<0>(inputparalagoritmos) = cotapesov;
                        cotapesov = cotapesov + variacionW;
                    }
                }
                i++;
                if (cual == 0) {
                    hacerfuerzabruta(inputparalagoritmos, k, entrega);
                }
                if (cual == 1) {
                    hacermeetinmiddle(inputparalagoritmos, k, entrega);
                }
                if (cual == 2) {
                    hacerbacktracking(inputparalagoritmos, k, entrega);
                }
                if (cual == 3) {
                    hacerprogdinamica(inputparalagoritmos, k, entrega);
                }
                if (cual < 0 || cual > 3) {
                    //testeo fuerza bruta total
                    cerr << "fuerzabruta" << endl;
                    tuple<int, int> rtafb;
                    rtafb = hacerfuerzabruta(inputparalagoritmos, k, entrega);

                    //testeo meet in the middle total
                    cerr << "meet in the middle" << endl;
                    tuple<int, int> rtamitmt;
                    rtamitmt = hacermeetinmiddle(inputparalagoritmos, k, entrega);

                    //testeo backtracking
                    cerr << "backtracking" << endl;
                    tuple<int, int, int> rtabktrack;
                    rtabktrack = hacerbacktracking(inputparalagoritmos, k, entrega);

                    //testeo programacion dinamica
                    cerr << "programacion dinamica" << endl;
                    tuple<int, int> rtaprogdinamica;
                    rtaprogdinamica = hacerprogdinamica(inputparalagoritmos, k, entrega);
                }

            }

        } else {
            if (cual == 0) {
                //testeo fuerza bruta total
                cerr << "fuerzabruta" << endl;
                tuple<int, int> rtafb;
                rtafb = hacerfuerzabruta(testlectoracncota, k, entrega);
            }
            if (cual == 1) {
                //testeo meet in the middle total
                cerr << "meet in the middle" << endl;
                tuple<int, int> rtamitmt;
                rtamitmt = hacermeetinmiddle(testlectoracncota, k, entrega);
            }
            if (cual == 2) {
                //testeo backtracking
                cerr << "backtracking" << endl;
                tuple<int, int, int> rtabktrack;
                rtabktrack = hacerbacktracking(testlectoracncota, k, entrega);
            }
            if (cual == 3) {
                //testeo programacion dinamica
                cerr << "programacion dinamica" << endl;
                tuple<int, int> rtaprogdinamica;
                rtaprogdinamica = hacerprogdinamica(testlectoracncota, k, entrega);
            }
            if (cual < 0 || cual > 3) {
                //testeo fuerza bruta total
                cerr << "fuerzabruta" << endl;
                tuple<int, int> rtafb;
                rtafb = hacerfuerzabruta(testlectoracncota, k, entrega);

                //testeo meet in the middle total
                cerr << "meet in the middle" << endl;
                tuple<int, int> rtamitmt;
                rtamitmt = hacermeetinmiddle(testlectoracncota, k, entrega);

                //testeo backtracking
                cerr << "backtracking" << endl;
                tuple<int, int, int> rtabktrack;
                rtabktrack = hacerbacktracking(testlectoracncota, k, entrega);

                //testeo programacion dinamica
                cerr << "programacion dinamica" << endl;
                tuple<int, int> rtaprogdinamica;
                rtaprogdinamica = hacerprogdinamica(testlectoracncota, k, entrega);
            }
        }
        cual++;
    }
    return 0;
}