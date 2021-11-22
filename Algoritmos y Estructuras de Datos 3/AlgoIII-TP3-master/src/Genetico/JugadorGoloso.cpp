#include "JugadorGoloso.h"

//recorrer tablero para calcular valores de los pesos a observar

//color 1 soy yo color 2 es el enemigo color 0 es vacio
void
contador(int &Clinea, int &enemigogana, vector<int> &cantyoseguidos, vector<int> &cantenemigoseguidos, int &acumulado,
         int &color, int &coloranterior, bool &libre, const int &c, int &ganador) {
    // auxiliar para contar

    //cuento caracteristicas de un tablero real para saber si ya termino o no con un c en linea (gano o pierdo
    if (acumulado >= c) {
        if (coloranterior == 1) {
            ganador = 1;
        }
        if (coloranterior == 2) {
            ganador = 2;
        }
    }

    //cuento caracteristicas sobre la jugada que estoy planeando aplicar (no en un tablero real si no en un tablero en 1 paso futuro)
    if (coloranterior != 0 && color != coloranterior) {//termino una linea y cuento lo que aporta
        if (color == 0) {//si termino en espacio libre
            libre = true;
        }
        if (libre) {//si la linea no esta bloqueada
            if (coloranterior == 1) {//soy yo
                if (acumulado >= c) {//gane
                    Clinea++;
                }
                cantyoseguidos[acumulado]++; //cuento
            }
            if (coloranterior == 2) {//es el enemigo
                if (acumulado >= c - 1) {//va a ganar en un turno
                    enemigogana++;
                }
                cantenemigoseguidos[acumulado]++; //cuento
            }
        } else { //no importa linea libre o bloqueada si en la jugada actual gano
            if (acumulado >= c && coloranterior == 1) {
                Clinea++;
            }
        }
    }

    if (color != 0 && coloranterior != color) {//comienza una linea
        if (coloranterior == 0) { //ya se de entrada que no esta bloqueada
            libre = true;
        } else { //hasta demostrar lo contrario no es libre
            libre = false;
        }
        acumulado = 1;
    }

    if (color == coloranterior && color != 0) {//alargo una linea de color
        acumulado++;
    }


}


//estas funciones devuelven void, devolver lo que deban devolver decidir a futuro, posiblemente devuelva f la funcion de puntaje de cada jugada
conteo recorrer(const tableroconalturas &T, const int &c) {
    int medidas = get<1>(T).size() + get<1>(T)[0].size(); //uso esta medida o c+1
    int Clinea = 0;
    int enemigogana = 0;
    vector<int> cantyoseguidos(medidas, 0);
    vector<int> cantenemigoseguidos(medidas, 0);
    int acumulado = 0;
    int color = -1;
    int coloranterior = -1;
    bool libre = false;
    int ganador = -1;

    const tablero &veotablero = get<1>(T);
    const columna &veoalturas = get<0>(T);
    //Recorrido de lineas acostadas _
    int i = 0;
    int j = 0;
    while (i < veotablero.size()) {
        j = 0;

        color = -1;
        coloranterior = -1;
        acumulado = 0;
        libre = false;
        while (j < veotablero[i].size()) {

            coloranterior = color;
            color = veotablero[i][j];
            contador(Clinea, enemigogana, cantyoseguidos, cantenemigoseguidos, acumulado, color, coloranterior, libre,
                     c, ganador);

            j++;
            if (j ==
                veotablero[i].size()) { //antes de salirme del while tengo que contar 1 vez mas porque sino me pierdo las filas que terminan en el borde
                coloranterior = color;
                color = -1;
                contador(Clinea, enemigogana, cantyoseguidos, cantenemigoseguidos, acumulado, color, coloranterior,
                         libre, c, ganador);
            }
        }
        i++;
    }

    //Recorrido de lineas verticales |
    i = 0;
    j = 0;
    color = -1;
    coloranterior = -1;
    acumulado = 0;
    libre = false;
    while (j < veotablero[0].size()) {
        i = 0;

        color = -1;
        coloranterior = -1;
        acumulado = 0;
        libre = false;
        while (i < veotablero.size()) {

            coloranterior = color;
            color = veotablero[i][j];
            contador(Clinea, enemigogana, cantyoseguidos, cantenemigoseguidos, acumulado, color, coloranterior, libre,
                     c, ganador);

            i++;
            if (i ==
                veotablero.size()) { //antes de salirme del while tengo que contar 1 vez mas porque sino me pierdo las filas que terminan en el borde
                coloranterior = color;
                color = -1;
                contador(Clinea, enemigogana, cantyoseguidos, cantenemigoseguidos, acumulado, color, coloranterior,
                         libre, c, ganador);
            }
        }
        j++;
    }

    //recorrido de diagonales (recorro estas diagonales ↘) \
    // empiezo en esquina inferior izquierda y voy subiendo en cada diagonal hasta terminar en esquina superior derecha,
    //cada diagonal la comienzo lo mas a la izquierda posible
    i = veotablero.size() - 1 + 1;  //inicio en esquina inferior izquierda
    j = 0;
    int largodiagonal = 0;
    bool pasecerocero = false;

    color = -1;
    coloranterior = -1;
    acumulado = 0;
    libre = false;
    while (!(j == veotablero[0].size() && i == 1)) {   //mientras no llegue a la esquina superior derecha
        if (!pasecerocero) { //para saber donde empieza la proxima diagonal depende de si ya pase por la diagonal que cruza el cero cero o no
            i = i - largodiagonal - 1;
            j = 0;
        } else {
            i = 0;
            j = j - largodiagonal + 1;

        }
        largodiagonal = 0;

        color = -1;
        coloranterior = -1;
        acumulado = 0;
        libre = false;
        while (j < veotablero[0].size() &&
               i < veotablero.size()) {  //cuando me salgo con alguno de los 2 indices subo a la proxima diagonal
            if (i == 0 && j == 0) {
                pasecerocero = true;
            }

            coloranterior = color;
            color = veotablero[i][j];
            contador(Clinea, enemigogana, cantyoseguidos, cantenemigoseguidos, acumulado, color, coloranterior, libre,
                     c, ganador);


            i++;
            j++;
            largodiagonal++;
            if (j == veotablero[0].size() || i ==
                                             veotablero.size()) { //cuando termino una diagonal hago el conteo de las filas q terminan en el borde
                coloranterior = color;
                color = -1;
                contador(Clinea, enemigogana, cantyoseguidos, cantenemigoseguidos, acumulado, color, coloranterior,
                         libre, c, ganador);
            }
        }
    }





    //recorrido de diagonales (recorro estas diagonlaes ↙)
    // empiezo en el cero cero y comienzo la diagonal lo mas arriba posible hasta terminar en el (N,M)
    i = 0;  //inicio en esquina superior izquierda
    j = -1;
    largodiagonal = 0;
    bool paseceroN = false;

    color = -1;
    coloranterior = -1;
    acumulado = 0;
    libre = false;
    while (!(j == veotablero[0].size() - 2 &&
             i == veotablero.size())) {   //mientras no llegue a la esquina inferior derecha (M,N)
        if (!paseceroN) { //para saber donde empieza la proxima diagonal depende de si ya pase por la diagonal que comienza en el (cero,N) N ancho de la matriz, cantidad de columnas
            j = j + largodiagonal + 1;
            i = 0;
        } else {
            i = i - largodiagonal + 1;
            j = veotablero[0].size() - 1;

        }
        largodiagonal = 0;

        color = -1;
        coloranterior = -1;
        acumulado = 0;
        libre = false;
        while (i < veotablero.size() &&
               j < veotablero[0].size()) {  //cuando me salgo con alguno de los 2 indices subo a la proxima diagonal
            if (i == 0 && j == veotablero[0].size() - 1) {
                paseceroN = true;
            }

            coloranterior = color;
            color = veotablero[i][j];
            contador(Clinea, enemigogana, cantyoseguidos, cantenemigoseguidos, acumulado, color, coloranterior, libre,
                     c, ganador);

            i++;
            j--;
            largodiagonal++;
            if (i == veotablero.size() || j == -1) {
                coloranterior = color;
                color = -1;
                contador(Clinea, enemigogana, cantyoseguidos, cantenemigoseguidos, acumulado, color, coloranterior,
                         libre, c, ganador);
            }
        }
    }

    //guardo en una tupla lo que conte
    conteo rta;
    //int Clinea; int enemigogana; vector<int> cantyoseguidos; vector<int> cantenemigoseguidos;
    get<0>(rta) = Clinea;
    get<1>(rta) = enemigogana;
    get<2>(rta) = cantyoseguidos;
    get<3>(rta) = cantenemigoseguidos;
    get<4>(rta) = ganador;

    return rta;
}


//veo un tablero y considero el puntaje de tal jugada
int evaluartablero(const tableroconalturas &T, const int &c, const int &pClinea, const int &penemigogana,
                   const int &pcantyoseguidos, const int &pcantenemigoseguidos) {
    int rta = 0;

    conteo contado = recorrer(T, c);
    const int &clinea = get<0>(contado);  //cantidad de fichas consecutivas propias con tamaño c
    const int &enemigogana = get<1>(
            contado);  // cantidad de fichas del oponente consecutivas con c-1 tamaño no bloqueadas
    const vector<int> &cantyoseguidos = get<2>(
            contado); // cantyoseguidos[i] te dice cuantos fichas conseguitvos de largo i hay no bloqueados y que se pueden alargar en proximo turno
    const vector<int> &cantenemigoseguidos = get<3>(contado); // analogo con fichas del enemigo


    int i = 0;
    int lineas = 0;
    while (i <
           cantyoseguidos.size()) {//sumo valores de distintos largos de lineas con un peso arbitrario fijado (que las mas grandes sean mas importantes)
        lineas = lineas + (((((i * 2) + 1) * ((i * 2) + 1)) * cantyoseguidos[i]));
        i++;

    }
    i = 0;
    int lineasenemigas = 0;
    while (i <
           cantenemigoseguidos.size()) {//sumo valores de distintos largos de lineas con un peso arbitrario fijado (que las mas grandes sean mas importantes)
        lineasenemigas = lineasenemigas + (((((i * 2) + 1) * ((i * 2) + 1)) * cantenemigoseguidos[i]));
        i++;
    }
    rta = rta + (clinea * pClinea) - (enemigogana * penemigogana) + (lineas * pcantyoseguidos) -
          (lineasenemigas * pcantenemigoseguidos);
    return rta;
}


int jugadagolosa(tableroconalturas &T, const int &c, const int &pClinea, const int &penemigogana,
                 const int &pcantyoseguidos, const int &pcantenemigoseguidos) {
    const vector<int> &Alturas = get<0>(T);
    int N = get<1>(T)[0].size();
    int M = get<1>(T).size();
    vector<int> puntajeddejugadas(N, INFINITONEGATIVO);
    int i = 0;
    while (i < puntajeddejugadas.size()) {//pongo una ficha a la vez y veo su puntaje de jugada y luego la saco
        int valordejugada;
        if (Alturas[i] < M) { //si la columna esta llena nisiquiera la observo
            ponerficha(T, i, 1);
            valordejugada = evaluartablero(T, c, pClinea, penemigogana, pcantyoseguidos, pcantenemigoseguidos);
            puntajeddejugadas[i] = valordejugada;
            sacarficha(T, i);
        }
        i++;
    }

    i = 0;
    int ganador = INFINITONEGATIVO;
    int dondegano = -1;
    while (i < puntajeddejugadas.size()) {//elijo jugada con major puntaje
        if (Alturas[i] < M && (puntajeddejugadas[i] > ganador || dondegano == -1)) {
            // si no pongo la ficha en lugar equivocado y (tengo un candidato mejor, o no tenia ningun candidato, entonces actualizo candidato
            ganador = puntajeddejugadas[i];
            dondegano = i;
        }
        i++;
    }
    return dondegano;

}


/*
//tiene que  usar get 4 de recorrer para saber quien gana
void jugadorgoloso(const int &pClinea, const int &penemigogana, const int &pcantyoseguidos,
                   const int &pcantenemigoseguidos) {

    //Definicion variables
    string coloryo;
    string colorel;
    int N;
    int M;
    int p;
    int c;
    string quienempieza;
    int turnode = 0;
    //Lectura variables
    //coloryo = read_str();
    //colorel = read_str();
    //N = read_int();
    //M = read_int();
    //c = read_int();
    //p = read_int();
    //quienempieza = read_str();


    if (quienempieza == "vos") {
        turnode = 1;
    }
    if (quienempieza == "el") {
        turnode = 2;
    }

    tableroconalturas T = iniciartablero(N, M);


    //int fichasrestantes=p*2;   3 variables para debugear
    //int casillasrestantes=N*M;
    //int ganador=-1;
    int posicionficha = -1;
    bool finalizar = false;

    if (turnode == 1) {
        posicionficha = jugadagolosa(T, c, pClinea, penemigogana, pcantyoseguidos, pcantenemigoseguidos);
        ponerficha(T, posicionficha, 1);
        cout << posicionficha << endl;
    }

    while (!finalizar) {//mientras no termino el juego

        string msg;
        msg = read_str();

        if (msg == "ganaste" || msg == "perdiste" || msg == "empataron") {
            finalizar = true;
        } else {
            //su jugada
            posicionficha = stoi(msg);//tradusco a posicion de ficha
            ponerficha(T, posicionficha, 2);

            //mi jugada
            posicionficha = jugadagolosa(T, c, pClinea, penemigogana, pcantyoseguidos, pcantenemigoseguidos);
            ponerficha(T, posicionficha, 1);
            cout << posicionficha << endl;
        }
        //ganador=get<4>(recorrer(T,c));//para debugear
        //turnode=(turnode%2+1);
        //fichasrestantes--;
        //casillasrestantes--;
    }
}
*/