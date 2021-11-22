#include "Tablero.h"


tableroconalturas iniciartablero(const int &N, const int &M) {  //COLUMNA FILA
    tablero tableroinicial(M, vector<int>(N, 0));  //tablero M FILAS N COLUMNAS
    columna alturasiniciales(N, 0);       //Vector con tamaño N columnas
    tableroconalturas tableroyalturainicial;  //me guardo una tupla <altura, tablero> donde altura es vector que indica la altura de la ficha mas alta de cada columna
    get<0>(tableroyalturainicial) = alturasiniciales;
    get<1>(tableroyalturainicial) = tableroinicial;
    return tableroyalturainicial;
}

//color 1 soy yo color 2 es enemigo
void ponerficha(tableroconalturas &T, const int &caercolummna, const int &color) {
    columna &alturavieja = get<0>(T);
    tablero &tableroviejo = get<1>(T);
    alturavieja[caercolummna]++;
    int calculoalturaaux;
    calculoalturaaux = tableroviejo.size() - alturavieja[caercolummna];
    tableroviejo[calculoalturaaux][caercolummna] = color;
}

void sacarficha(tableroconalturas &T, const int &caercolummna) {
    columna &alturavieja = get<0>(T);
    tablero &tableroviejo = get<1>(T);
    int calculoalturaaux;
    calculoalturaaux = tableroviejo.size() - alturavieja[caercolummna];
    tableroviejo[calculoalturaaux][caercolummna] = 0;
    alturavieja[caercolummna]--;
}




