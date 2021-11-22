/* ** por compatibilidad se omiten tildes **
================================================================================
 TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
================================================================================
*/

#include "game.h"

uint32_t tareasMuertas=0;

void calcTareasMuertas(){
    tareasMuertas=0;
    for (int i = 4; i < 24; i++)
    {
        if(tareasVivas[i] == 0) tareasMuertas++;
    }
}


void game_init() {
    for (int i = 0; i < 4; i++)
    {
        posPortal[i]=0;    // 0 ,1= Rc137,Mc137 , 2,3=d248
        posPortalOld[i]=0;
    }
    contadorPuntos[0]=0;
    contadorPuntos[1]=0;
    for (int i = 0; i < 24; i++)
    {
        tareasVivas[i]=1;
    }
    

}

void endGame(uint16_t codigoGanador){

                //y   x
    screen_drawBox(23,26,3,28,0,0x55);
                                //x   y
    print("El ganador es el rick ",27,24,0xf1);
    print_hex(codigoGanador,4,49,24,0xf1);
    while (1)
    {
        hlt();
    }
    
}

void endGamePuntos(uint16_t codigoGanador){
    endGame(codigoGanador);
}

void endGameLoDominaron(uint16_t codigoPerdedor){
    if(codigoPerdedor==0xc137) endGame(0xd248);
    else endGame(0xc137);
    
}
void endGameExepcion(uint16_t selectorPerdedor){
    uint16_t select = rtr();
    uint16_t indice = select >> 3;
    if(indice == 15) endGame(0xc137);
    else endGame(0xd248);
}

void endGameMurioPisado(uint8_t indice){
    breakpoint();
    if(indice < 2) endGame(0xd248);
    else endGame(0xc137);
}


