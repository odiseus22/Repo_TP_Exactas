/* ** por compatibilidad se omiten tildes **
================================================================================
 TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
================================================================================
  definicion de funciones del scheduler
*/

#include "sched.h"

uint32_t tareasVivas[24];

uint32_t CronenbergsOcupadas[24]={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}; 
//Si una tarea Cronenberg es ocupada el numero indica que equipo la posee, 1 indica equpio c137 2 indica equipo d248, 0 no fue pisada


uint16_t indicesGDTtareas[24]={GDT_OFF_TAREA_RICK_C137,GDT_OFF_TAREA_MORTY_C137,GDT_OFF_TAREA_RICK_D248,GDT_OFF_TAREA_MORTY_D248,GDT_OFF_TAREA_CRONENBERG(1),
GDT_OFF_TAREA_CRONENBERG(2),GDT_OFF_TAREA_CRONENBERG(3),GDT_OFF_TAREA_CRONENBERG(4),GDT_OFF_TAREA_CRONENBERG(5),
 GDT_OFF_TAREA_CRONENBERG(6),GDT_OFF_TAREA_CRONENBERG(7),GDT_OFF_TAREA_CRONENBERG(8),GDT_OFF_TAREA_CRONENBERG(9),GDT_OFF_TAREA_CRONENBERG(10),GDT_OFF_TAREA_CRONENBERG(11),
 GDT_OFF_TAREA_CRONENBERG(12),GDT_OFF_TAREA_CRONENBERG(13),GDT_OFF_TAREA_CRONENBERG(14),GDT_OFF_TAREA_CRONENBERG(15),GDT_OFF_TAREA_CRONENBERG(16),GDT_OFF_TAREA_CRONENBERG(17),
 GDT_OFF_TAREA_CRONENBERG(18),GDT_OFF_TAREA_CRONENBERG(19),GDT_OFF_TAREA_CRONENBERG(20)}; 

uint32_t usadoPortalRickDispMorty[4]={0,0,0,0};  //en este arreglo se setea cada vez que rick hace un portal, eso por un lado.Por el otro lado tambien se stackean los portales de Morty
int INDICETAREAS;




uint32_t abs(int32_t value) {
  if (value < 0)
    return -value;
  return value;  
}


//funcion auxiliar para saber que tarea soy y donde estoy, para las interrupciones 
//uint32_t direccionesCronenberg[24];

void whereIsMortyAux(uint32_t* x,uint32_t* y){

  
  uint16_t selector_actual =rtr(); //me indica selector de segmento actual
  selector_actual=selector_actual >> 3;
  //cuentas para ajustar indices
  uint16_t ind_Direcc=selector_actual-15;   //resto 15 porque tengo valores entre 15 y 24 y consigo el indice
  if(ind_Direcc<0  ||  ind_Direcc>24){
    return ;
  }
  uint32_t direccionFiscaRick=posActualTareas[ind_Direcc];
  uint32_t direccionFiscaMorty=posActualTareas[ind_Direcc+1];
  //las tareas viven en un mundo de 80x40      

  //10x5
  //21 (tercer fila offset+1)
  //ancho=dividir por 10 y obtengo la y en cociente(parte entera sin usar los decimales) (sumarle 1) 
  //offset= el resto de dividir por 10  es el offset 
                                          
  //pirmer direcFisica es 0x400000

  uint32_t yRick = ( direccionFiscaRick-0x400000 ) / 0x2000 / 80;
  uint32_t xRick = ( direccionFiscaRick-0x400000 ) / 0x2000 - yRick * 80;
  uint32_t yMorty = ( direccionFiscaMorty-0x400000 ) / 0x2000 / 80;
  uint32_t xMorty = ( direccionFiscaMorty-0x400000 ) / 0x2000 - yMorty * 80;
  uint32_t xDesplz= xMorty-xRick;
  uint32_t yDesplz= yMorty-yRick;
  *x=xDesplz;
  *y=yDesplz;
} 



void sched_init() {
  INDICETAREAS=-1;
  
}

int16_t sched_nextTask() {
	INDICETAREAS++;
	if (INDICETAREAS == 24) INDICETAREAS=0;
	if(tareasVivas[INDICETAREAS] == 1){
		 return (indicesGDTtareas[INDICETAREAS] >> 3) << 3; 		//si esta tarea esta viva entonces la retorno
		 }
    else{
		uint16_t res= sched_nextTask(); 	//sino pruebo con la siguiente
		 return res;
		 }				
}


void matarTarea(uint32_t index){
	
	tareasVivas[index]=0;
	matarTareaAux();	//salto a tarea idle
}


int32_t usePortalGun(int32_t x,int32_t y,uint32_t cross, uint32_t withMorty){

	int i=0;
	for (i = 0; i < 24; i++)
	{
		if( indicesGDTtareas[i] == rtr() ) break;
	}
	//luego posActual[i] tiene mi direccion

	int32_t yRickActual;
 	int32_t xRickActual;
	int32_t yMortyActual;
  	int32_t xMortyActual;


	uint32_t meLlamoUnRick=0;
    uint32_t direcPortalRick=0;
    uint32_t direcPortalMorty=0; 



    if( (i==0) || (i==2)){
	  //soy una tarea Rick
	 if(usadoPortalRickDispMorty[i]) return 0;

	 usadoPortalRickDispMorty[i]++;
	 meLlamoUnRick=1;
	 usadoPortalRickDispMorty[i+1]++;

	 yRickActual = ( posActualTareas[i]-0x400000 ) / 0x2000 / 80;
 	 xRickActual = ( posActualTareas[i]-0x400000 ) / 0x2000 - yRickActual * 80;
	 yMortyActual = ( posActualTareas[i+1]-0x400000 ) / 0x2000 / 80;
  	 xMortyActual = ( posActualTareas[i+1]-0x400000 ) / 0x2000 - yMortyActual * 80;

 	 
 	}
 	else if ((i==1) || (i==3)){
		 //soy un morty
	  if( usadoPortalRickDispMorty[i] / 10 >= 1 ) usadoPortalRickDispMorty[i]-=10;
	  	else return 0;

	  yMortyActual = ( posActualTareas[i]-0x400000 ) / 0x2000 / 80;
  	  xMortyActual = ( posActualTareas[i]-0x400000 ) / 0x2000 - yMortyActual * 80;

 	}
	else {
		//soy un cronenberg
		matarTarea(i);
		return 0;
	}
	
	//if ( (xRickActual + x ) >=80) breakpoint(); breakpoints para debugear si nos salimos de la pantalla
	//if ( (yRickActual + y) >=40) breakpoint();
	//if ( (xMortyActual + x ) >=80) breakpoint();
	//if ( (yMortyActual + y) >=40) breakpoint();
	uint32_t xRickFinal = (xRickActual +80 + x )% 80;
	uint32_t yRickFinal = (yRickActual +40 + y ) % 40;
	uint32_t xMortyFinal = (xMortyActual +80 + x ) % 80;
	uint32_t yMortyFinal = (yMortyActual +40 + y) % 40;

	direcPortalRick = (xRickFinal + yRickFinal * 80) *0x2000 + 0x400000;
 	direcPortalMorty = (xMortyFinal + yMortyFinal * 80) *0x2000 + 0x400000;

	//antes chequeamos si vamos a pisar una tarea
	
	/*if(cross){                               <----  NO MATAMOS APROPOSITO LA TAREA (este codigo MATABA la tarea al visitarla)
		for (int k = 0; k < 24; k++)
		{
			if(i!=k){
				if(meLlamoUnRick){
					if( withMorty && (direcPortalRick == posActualTareas[k] || direcPortalMorty == posActualTareas[k] )){
						if(k<3) endGameMurioPisado(k); // o sea, vamos a pisar un Rick o un Morty           
						else matarTarea(k);  //como es un cronenberg y lo pisamos lo matamos.
				}
				else if( !withMorty && (direcPortalRick == posActualTareas[k]) ){
					if(k<3) endGameMurioPisado(k); // o sea, vamos a pisar un Rick o un Morty           
					else matarTarea(k);  //como es un cronenberg y lo pisamos lo matamos.
				}
			}
			else{
				if(direcPortalMorty == posActualTareas[k] ){
					if(k<3) endGameMurioPisado(k); // o sea, vamos a pisar un Rick o un Morty           
						else matarTarea(k);  //como es un cronenberg y lo pisamos lo matamos.
				}
			}
		}
	}*/

	//luego vemos los casos posibles con morty, cross
	if(meLlamoUnRick){
  		if(!cross){
	 		if(!withMorty){  
				// CROSS=0 MORTY=0
				mmu_mapPage(rcr3(),0x08002000,direcPortalRick,1,1);
				mmu_mapPage(rcr3(),0x08002000+PAGE_SIZE,direcPortalRick+PAGE_SIZE,1,1);
				posPortal[i]=direcPortalRick;
			}
		    else{
				// CROSS=0 MORTY=1
				//breakpoint();
				mmu_mapPage(rcr3(),0x08002000,direcPortalRick,1,1);
			  	mmu_mapPage(rcr3(),0x08002000+PAGE_SIZE,direcPortalRick+PAGE_SIZE,1,1);
				//conseguir cr3 de morty
				uint32_t indexGDTMortyTssDescritor = i+1 +(15);

				uint32_t direcTSSMORTY = gdt[indexGDTMortyTssDescritor].base_31_24;
				direcTSSMORTY = (direcTSSMORTY << 8 ) + gdt[indexGDTMortyTssDescritor].base_23_16;
				direcTSSMORTY = (direcTSSMORTY << 16) + gdt[indexGDTMortyTssDescritor].base_0_15;

				tss* tssPtrMorty = (tss*) direcTSSMORTY;

				uint32_t mortyCr3=tssPtrMorty->cr3;
				//breakpoint(); 
				mmu_mapPage(mortyCr3,0x08002000,direcPortalMorty,1,1);
	 		 	mmu_mapPage(mortyCr3,0x08002000+PAGE_SIZE,direcPortalMorty+PAGE_SIZE,1,1);
				posPortal[i]=direcPortalRick;
			}
 	    }
		else{
			if(!withMorty){
				// CROSS=1 MORTY=0
				
				mmu_mapPage(rcr3(),direcPortalRick,direcPortalRick,1,1); 	//mapeo direccion destino con id (MODO USUARIO Y READ/WRITE)
				mmu_mapPage(rcr3(),direcPortalRick+PAGE_SIZE,direcPortalRick+PAGE_SIZE,1,1);
				//copio
				
				uint8_t* dst = (uint8_t*) (direcPortalRick); // esta al reves
				uint8_t* src = (uint8_t*) (0x08000000);
				for (int i = 0; i < 0x2000; i++){
					dst[i]=src[i];
			}
			//remapeo
			mmu_mapPage(rcr3(),0x08000000,direcPortalRick,1,1);
	 	 	mmu_mapPage(rcr3(),0x08000000+PAGE_SIZE,direcPortalRick+PAGE_SIZE,1,1);
			//y por ultimo desmapeo el aux
			mmu_unmapPage(rcr3(),direcPortalRick); 	//mapeo direccion destino con id
	  		mmu_unmapPage(rcr3(),direcPortalRick+PAGE_SIZE);
			//por ultimo actualizo su posicion en el array
			
			posActualTareas[i]=direcPortalRick;
  
		    }
		   else{
				// CROSS=1 MORTY=1
				
				mmu_mapPage(rcr3(),direcPortalRick,direcPortalRick,1,1); 	//mapeo direccion destino con id
	 		 	mmu_mapPage(rcr3(),direcPortalRick+PAGE_SIZE,direcPortalRick+PAGE_SIZE,1,1);
				//copio
				uint8_t* dst = (uint8_t*) (direcPortalRick); 
				uint8_t* src = (uint8_t*) (0x08000000);
				for (int i = 0; i < 0x2000; i++){
					dst[i]=src[i];
				}
				//remapeo
				mmu_mapPage(rcr3(),0x08000000,direcPortalRick,1,1);
	 		 	mmu_mapPage(rcr3(),0x08000000+PAGE_SIZE,direcPortalRick+PAGE_SIZE,1,1);
				//y por ultimo desmapeo el aux
				mmu_unmapPage(rcr3(),direcPortalRick); 	//mapeo direccion destino con id
	  			mmu_unmapPage(rcr3(),direcPortalRick+PAGE_SIZE);

				/* AHORA ARRANCO CON MORTY */

				//guardo old cr3
				uint32_t oldCr3= rcr3();
				//conseguir cr3 de morty
				uint32_t indexGDTMortyTssDescritor = i+1 +(15);

				uint32_t direcTSSMORTY = gdt[indexGDTMortyTssDescritor].base_31_24;
				direcTSSMORTY = (direcTSSMORTY << 8 ) + gdt[indexGDTMortyTssDescritor].base_23_16;
				direcTSSMORTY = (direcTSSMORTY << 16) + gdt[indexGDTMortyTssDescritor].base_0_15;

				tss* tssPtrMorty = (tss*) direcTSSMORTY;

				uint32_t mortyCr3=tssPtrMorty->cr3;
				//cargo cr3 de tarea morty
				lcr3(mortyCr3);
				mmu_mapPage(rcr3(),direcPortalMorty,direcPortalMorty,1,1); 	//mapeo direccion destino con id
			  	mmu_mapPage(rcr3(),direcPortalMorty+PAGE_SIZE,direcPortalMorty+PAGE_SIZE,1,1);
				//copio
				dst = (uint8_t*) (direcPortalMorty); 
				src = (uint8_t*) (0x08000000);
				for (int i = 0; i < 0x2000; i++){
					dst[i]=src[i];
				}
				//remapeo
				mmu_mapPage(mortyCr3,0x08000000,direcPortalMorty,1,1);
	 		 	mmu_mapPage(mortyCr3,0x08000000+PAGE_SIZE,direcPortalMorty+PAGE_SIZE,1,1);
				//y por ultimo desmapeo el aux
				mmu_unmapPage(mortyCr3,direcPortalMorty); 	//mapeo direccion destino con id
	 		 	mmu_unmapPage(mortyCr3,direcPortalMorty+PAGE_SIZE);
				//vuelvo a cargar el cr3
				lcr3(oldCr3);
				//por ultimo actualizo su posicion en el array
				
			    posActualTareas[i]=direcPortalRick;
				posActualTareas[i+1]=direcPortalMorty;
			}

		}
	}
else{
	//me llamo un morty
	if(cross){
		mmu_mapPage(rcr3(),direcPortalMorty,direcPortalMorty,1,1); 	//mapeo direccion destino con id
	  	mmu_mapPage(rcr3(),direcPortalMorty+PAGE_SIZE,direcPortalMorty+PAGE_SIZE,1,1);
		//copio
		uint8_t* dst = (uint8_t*) (direcPortalMorty); 
		uint8_t* src = (uint8_t*) (0x08000000);
		for (int i = 0; i < 0x2000; i++){
			dst[i]=src[i];
		}
		//remapeo
		mmu_mapPage(rcr3(),0x08000000,direcPortalMorty,1,1);
	  	mmu_mapPage(rcr3(),0x08000000+PAGE_SIZE,direcPortalMorty+PAGE_SIZE,1,1);
		//y por ultimo desmapeo el aux
		mmu_unmapPage(rcr3(),direcPortalMorty); 	//mapeo direccion destino con id
	  	mmu_unmapPage(rcr3(),direcPortalMorty+PAGE_SIZE);
		//por ultimo actualizo su posicion en el array
		posActualTareas[i]=direcPortalMorty;
	}
	else{
		mmu_mapPage(rcr3(),0x08002000,direcPortalMorty,1,1);
	  	mmu_mapPage(rcr3(),0x08002000+PAGE_SIZE,direcPortalMorty+PAGE_SIZE,1,1);
		posPortal[i]=direcPortalMorty;
	}
}
return 1;
}


void iAmRickAux(uint16_t code){

	int i=0;
	for (i = 0; i < 24; i++)
	{
		if( indicesGDTtareas[i] == rtr() ) break;
	}
	
	if (code == 0xC137){
		 if ( i == 2 ) endGameLoDominaron(0xD248);     // <--- o sea un Rick conquisto la mente de otro Rick
		 //contadorPuntos[0]++;
	}
	else if (code == 0xD248){
		 if ( i == 0 ) endGameLoDominaron(0xC137);
		 //contadorPuntos[1]++;
	}

	if(i>3){//solo reviso las tareas cronenberg
		if (code == 0xC137){
			if ( CronenbergsOcupadas[i] == 0)  contadorPuntos[0]++;
			if ( CronenbergsOcupadas[i] == 2) { //si es del otro equipo
				contadorPuntos[0]++;
				contadorPuntos[1]--;
			}
			CronenbergsOcupadas[i]=1;
		}
		if (code == 0xD248){
			if ( CronenbergsOcupadas[i] == 0)  contadorPuntos[1]++;
			if ( CronenbergsOcupadas[i] == 1) { //si es del otro equipo
				contadorPuntos[0]--;
				contadorPuntos[1]++;
			}
			CronenbergsOcupadas[i]=2;
		}
	}


//<------------------------------------------------------------------------ QUEREMOS QUE CADA CRONENBERG SUME 1 SOLA VEZ
//PUNTAJE = SUMA DE TODAS LAS TAREAS CONQUISTADAS POR ESE RICK
//SI JUGADOR AZUL LE CAPTURA AL ROJO EL AZUL GANA PUNTO Y EL ROJO PIERDE
	//matarTarea(i);  <- NO QUEREMOS MATAR TAREA

//CREO UN VECTOR, PUEDE SER 0 1 2,  SIN EQUIPO ROJO AZUL,  SUMO SOLAMENTE SI CAMBIO DE VALOR  SI CAMBIO DE ROJO A AZUL, RESTO 1 A ROJO SUMO 1 A AZUL
//SI ESTABA EN JUGADOR 1 Y PASA A JUGADOR 1 NO PASA NADA

}