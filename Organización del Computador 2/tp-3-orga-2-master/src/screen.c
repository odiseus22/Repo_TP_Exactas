/* ** por compatibilidad se omiten tildes **
================================================================================
 TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
================================================================================
  definicion de funciones del scheduler
*/

#include "screen.h"




uint8_t pantallaBackup[0x1f3f];
extern uint8_t funcionMagica();

void print(const char* text, uint32_t x, uint32_t y, uint16_t attr) {
    ca (*p)[VIDEO_COLS] = (ca (*)[VIDEO_COLS]) VIDEO; // magia
    int32_t i;
    for (i = 0; text[i] != 0; i++) {
        p[y][x].c = (uint8_t) text[i];
        p[y][x].a = (uint8_t) attr;
        x++;
        if (x == VIDEO_COLS) {
            x = 0;
            y++;
        }
    }
}

void print_dec(uint32_t numero, uint32_t size, uint32_t x, uint32_t y, uint16_t attr) {
    ca (*p)[VIDEO_COLS] = (ca (*)[VIDEO_COLS]) VIDEO; // magia
    uint32_t i;
    uint8_t letras[16] = "0123456789";

    for(i = 0; i < size; i++) {
        uint32_t resto  = numero % 10;
        numero = numero / 10;
        p[y][x + size - i - 1].c = letras[resto];
        p[y][x + size - i - 1].a = attr;
    }
}

void print_hex(uint32_t numero, int32_t size, uint32_t x, uint32_t y, uint16_t attr) {
    ca (*p)[VIDEO_COLS] = (ca (*)[VIDEO_COLS]) VIDEO; // magia
    int32_t i;
    uint8_t hexa[8];
    uint8_t letras[16] = "0123456789ABCDEF";
    hexa[0] = letras[ ( numero & 0x0000000F ) >> 0  ];
    hexa[1] = letras[ ( numero & 0x000000F0 ) >> 4  ];
    hexa[2] = letras[ ( numero & 0x00000F00 ) >> 8  ];
    hexa[3] = letras[ ( numero & 0x0000F000 ) >> 12 ];
    hexa[4] = letras[ ( numero & 0x000F0000 ) >> 16 ];
    hexa[5] = letras[ ( numero & 0x00F00000 ) >> 20 ];
    hexa[6] = letras[ ( numero & 0x0F000000 ) >> 24 ];
    hexa[7] = letras[ ( numero & 0xF0000000 ) >> 28 ];
    for(i = 0; i < size; i++) {
        p[y][x + size - i - 1].c = hexa[i];
        p[y][x + size - i - 1].a = attr;
    }
}

void screen_drawBox(uint32_t fInit,
                    uint32_t cInit,
                    uint32_t fSize,
                    uint32_t cSize,
                    uint8_t character,
                    uint8_t attr ) {
    ca (*p)[VIDEO_COLS] = (ca (*)[VIDEO_COLS]) VIDEO;
    uint32_t f;
    uint32_t c;
    for (f = fInit; f < fInit+fSize; f++) {
    for (c = cInit; c < cInit+cSize; c++) {
          p[f][c].c = character;
          p[f][c].a = attr;
    }}
}

void print_interrupt(uint32_t numero_int){

       uint8_t *displayPointer = (uint8_t*) 0xB8000;
    for (int i = 0; i < 0x1f3f; i++)
        {
            pantallaBackup[i]=displayPointer[i];
               
        }
    
    uint32_t interrupt=numero_int;
    screen_drawBox(0,25,34,29,0,0x55);
    screen_drawBox(1,26,32,27,0,0x0);
    print("interrupcion numero: ",28,2,0xCC);
    print_dec(interrupt,2,49,2,0x4C);
    
}

uint8_t modoDebugOn=0;
uint32_t estoyEnExepcionModoDebug = 0;


void printScanCode(uint32_t x){
    uint8_t posiblesTeclas[]={0x0B,0x02,0x03,0x04,0x05,0x06,0x07,0x08,0x09,0x0A};
    for(int i=0 ;i<10 ;i++){
        if ( x == posiblesTeclas[i]){
            print_dec(i,1,79,0,0x4A);
        }
    }
    if (x==0x15){
        modoDebugOn=1;        //chequeo si la tecla y fue presionada
        if(estoyEnExepcionModoDebug == 1){
            uint8_t* displayPointer = (uint8_t*) 0xB8000;
            for (int i = 0; i < 0x1f3f; i++){
                    
                    displayPointer[i]=pantallaBackup[i];
            }
            estoyEnExepcionModoDebug=0;
            //por ultimo, ya que estamos matamos a la tarea por tirar una exepcion
                
            uint16_t selector = rtr();
            uint16_t indice = selector >> 3;
            if (indice > 14 && indice < 40){
            uint16_t indiceTareas= indice-15;
            matarTarea(indiceTareas);
            }
        }
    }
}
void printStringNumero(const char* text, uint32_t sizeString, uint32_t numero,uint32_t sizeNum, uint32_t x, uint32_t y){
    print(text,x,y,0x0A);
    print_dec(numero,sizeNum,x+sizeString+1,y,0x0A);
}

void printStringNumeroHexa(const char* text, uint32_t sizeString, uint32_t numero,uint32_t sizeNum, uint32_t x, uint32_t y){
    print(text,x,y,0x0A);
    print_hex(numero,sizeNum,x+sizeString+1,y,0x0A);
}


void screen_init(){
    screen_drawBox(0,0,40,80,0,0x22);
    screen_drawBox(40,0,10,80,0,0x00);
    screen_drawBox(42,1,6,10,0,0x11);
    print("c137",4,41,0x1f);
    screen_drawBox(42,69,6,10,0,0x44);
    print("d248",72,41,0x4f);



    //interfaz tareas cronenberg
    printStringNumeroHexa("",0,0x00,2,24,43);
    printStringNumeroHexa("",0,0x01,2,27,43);
    printStringNumeroHexa("",0,0x02,2,30,43);
    printStringNumeroHexa("",0,0x03,2,33,43);
    printStringNumeroHexa("",0,0x04,2,36,43);
    printStringNumeroHexa("",0,0x05,2,39,43);
    printStringNumeroHexa("",0,0x06,2,42,43);
    printStringNumeroHexa("",0,0x07,2,45,43);
    printStringNumeroHexa("",0,0x08,2,48,43);
    printStringNumeroHexa("",0,0x09,2,51,43);
    //fila 2
    printStringNumeroHexa("",0,0x10,2,24,46);
    printStringNumeroHexa("",0,0x11,2,27,46);
    printStringNumeroHexa("",0,0x12,2,30,46);
    printStringNumeroHexa("",0,0x13,2,33,46);
    printStringNumeroHexa("",0,0x14,2,36,46);
    printStringNumeroHexa("",0,0x15,2,39,46);
    printStringNumeroHexa("",0,0x16,2,42,46);
    printStringNumeroHexa("",0,0x17,2,45,46);
    printStringNumeroHexa("",0,0x18,2,48,46);
    printStringNumeroHexa("",0,0x19,2,51,46);


    /*;;  Color:
;;      * Bit #: 7 6 5 4 3 2 1 0
;;               | | | | | | | |
;;               | | | | | ^-^-^-- Fore color
;;               | | | | ^-------- Fore color bright bit
;;               | ^-^-^---------- Back color
;;               ^---------------- Back color bright bit OR enables blinking text
;;      rojo con fondo rojo claro =01000100 =44
        verde con fondo verde = 00100010 =ox22
*/
    //estan vivas?
    //fila1
    print("si",25,44,0x22);
    print("si",28,44,0x22);
    print("si",31,44,0x22);
    print("si",34,44,0x22);
    print("si",37,44,0x22);
    print("si",40,44,0x22);
    print("si",43,44,0x22);
    print("si",46,44,0x22);
    print("si",49,44,0x22);
    print("si",52,44,0x22);
    //fila2
    print("si",25,47,0x22);
    print("si",28,47,0x22);
    print("si",31,47,0x22);
    print("si",34,47,0x22);
    print("si",37,47,0x22);
    print("si",40,47,0x22);
    print("si",43,47,0x22);
    print("si",46,47,0x22);
    print("si",49,47,0x22);
    print("si",52,47,0x22);




}




void imprimirDebug(
uint32_t ss,uint32_t esp,uint32_t eflags,uint32_t cs,uint32_t eip,uint32_t eax,uint32_t ecx,uint32_t edx,uint32_t ebx,uint32_t ebp,uint32_t esi,uint32_t edi
){


    screen_drawBox(4,25,36,29,0,0x55);
    screen_drawBox(5,26,34,27,0,0x0);

    //primer columna de parametros
    printStringNumeroHexa("eax",3,eax,8,27,7);
    printStringNumeroHexa("ebx",3,ebx,8,27,9);
    printStringNumeroHexa("ecx",3,ecx,8,27,11);
    printStringNumeroHexa("edx",3,edx,8,27,13);
    printStringNumeroHexa("esi",3,esi,8,27,15);
    printStringNumeroHexa("edi",3,edi,8,27,17);
    printStringNumeroHexa("ebp",3,ebp,8,27,19);
    printStringNumeroHexa("esp",3,esp,8,27,21);
    printStringNumeroHexa("eip",3,eip,8,27,23);
    printStringNumeroHexa(" cs",3,cs,8,27,25);
    printStringNumeroHexa(" ds",3,cs,8,27,27);
    printStringNumeroHexa(" es",3,cs,8,27,29);
    printStringNumeroHexa(" fs",3,cs,8,27,31);
    printStringNumeroHexa(" gs",3,cs,8,27,33);
    printStringNumeroHexa(" ss",3,ss,8,27,35);
    printStringNumeroHexa("eflags",6,eflags,8,27,37);

    //segunda columna de parametros
    printStringNumeroHexa("cr0",3,rcr0(),8,40,7);
    printStringNumeroHexa("cr2",3,rcr2(),8,40,9);
    printStringNumeroHexa("cr3",3,rcr3(),8,40,11);
    printStringNumeroHexa("cr4",3,rcr4(),8,40,13);


    printStringNumeroHexa("stack",4,0,0,40,15);
    uint32_t* esp_ptr= (uint32_t*)  esp;
 
    for (int i = 0; i < ebp-esp && i<4*4; i+=4)
    {
        if( ebp <= esp+i){
            printStringNumeroHexa("",0,esp_ptr[i/4],8,40,17+i/4);
        }
        else{
            printStringNumeroHexa("",0,0,8,40,17+i/4);
        }
    }
}

uint8_t yaPinteLosCronen=0;

void imprimirJugadores(){

    if(!yaPinteLosCronen){
        for (int i = 4; i < 24; i++){
             uint32_t y = ( posActualTareas[i]-0x400000 ) / 0x2000 / 80;
             uint32_t x = ( posActualTareas[i]-0x400000 ) / 0x2000 - y * 80 ;
             print("C",x,y,0xEF27);
        }
    }
    

    for (int i = 0; i < 4; i++)
    {
    uint8_t repintar = 0;
    uint32_t yOld;
    uint32_t xOld;
    if(posActualTareas[i] != posAnteriorTareas[i]){        /*me fijo si el jugador se movio, si se movio lo registro para la proxima tener la pos correcta*/
         repintar = 1;
         yOld = ( posAnteriorTareas[i]-0x400000 ) / 0x2000 / 80;
         xOld = ( posAnteriorTareas[i]-0x400000 ) / 0x2000 - yOld * 80 ;
         posAnteriorTareas[i]=posActualTareas[i];
    }
    uint32_t y = ( posActualTareas[i]-0x400000 ) / 0x2000 / 80;
    uint32_t x = ( posActualTareas[i]-0x400000 ) / 0x2000 - y * 80 ;
  
    switch( i ){

   case 0 :
        if(repintar) print(".",xOld,yOld,0x22);       //pinto arriba
        print("R",x,y,0xEF21);   //azul
       
        break;
    case 1 :
        if(repintar) print(".",xOld,yOld,0x22);       //pinto arriba
        print("M",x,y,0xEF21);

        break;
    case 2 :
        if(repintar) print(".",xOld,yOld,0x22);       //RICK D248 (COLOR rojo)
        print("R",x,y,0xEF24);
        break;
    case 3 :
        if(repintar) print(".",xOld,yOld,0x22);       //pinto arriba
        print("M",x,y,0xEF24);
        break;
    

        }
    }

    for (int i = 0; i < 4; i++){
        uint8_t repintar = 0;
        uint32_t yOld;
        uint32_t xOld;
        if(posPortal[i] != posPortalOld[i]){        /*me fijo si el jugador se movio, si se movio lo registro para la proxima tener la pos correcta*/
            repintar = 1;
            yOld = ( posPortalOld[i]-0x400000 ) / 0x2000 / 80;
            xOld = ( posPortalOld[i]-0x400000 ) / 0x2000 - yOld * 80 ;
            posPortalOld[i]=posPortal[i];
        }
        uint32_t y = ( posPortal[i]-0x400000 ) / 0x2000 / 80;
        uint32_t x = ( posPortal[i]-0x400000 ) / 0x2000 - y * 80 ;
        
        if(posPortal[i] != 0){
            print("O",x,y,0xD1);
            if(repintar) print(".",xOld,yOld,0x22); 
        }
    }
    
    yaPinteLosCronen=1;

    print_dec(contadorPuntos[0],8,2,44,0xEF17);
    print_dec(contadorPuntos[1],8,70,44,0xEF47);

    if(contadorPuntos[0]+tareasMuertas == MAX_CANTIDAD_PUNTOS) endGamePuntos(0xc137);
        else if (contadorPuntos[1]+tareasMuertas == MAX_CANTIDAD_PUNTOS) endGamePuntos(0xd248);

   //actualizamos en pantalla si esta viva o no una tarea cronenberg 
   //uint32_t tareasVivas[24]={1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}; asi se inicializa
    //la primer tarea cronenberg es la 5ta i=4
   for (int i=4; i < 24; i++)
   {
       if(tareasVivas[i]==0){ 
            if(i<14){
                print("no",25+((i-4)*3),44,0x44);                 //la tarea se encuentra en la primer fila de la interfaz visual
            } else{
                print("no",25+((i-4-10)*3),47,0x44);              //la tarea se encuentra en la segunda fila de la interfaz visual
            }
            uint32_t y = ( posActualTareas[i]-0x400000 ) / 0x2000 / 80;
            uint32_t x = ( posActualTareas[i]-0x400000 ) / 0x2000 - y * 80 ;
            print("C",x,y,0xEF22);      //pinto verde para asegurarme que se borre de la pantalla
        }
        if(tareasVivas[i]==1){
            if(CronenbergsOcupadas[i]==0){
                uint32_t y = ( posActualTareas[i]-0x400000 ) / 0x2000 / 80;
                uint32_t x = ( posActualTareas[i]-0x400000 ) / 0x2000 - y * 80 ;
                print("C",x,y,0xEF27);   // pintar de color gris
            }
            if(CronenbergsOcupadas[i]==1){
                uint32_t y = ( posActualTareas[i]-0x400000 ) / 0x2000 / 80;
                uint32_t x = ( posActualTareas[i]-0x400000 ) / 0x2000 - y * 80 ;
                print("C",x,y,0xEF21);   // pintar de color azul
            }
            if(CronenbergsOcupadas[i]==2){
                uint32_t y = ( posActualTareas[i]-0x400000 ) / 0x2000 / 80;
                uint32_t x = ( posActualTareas[i]-0x400000 ) / 0x2000 - y * 80 ;
                print("C",x,y,0xEF24);   // pintar de color rojo
            }


        }
    }
}

void libretas(){
    print("502/17 595/18",27,2,0x4A);    // 502/17 595/18        video a 80 X 50
}
