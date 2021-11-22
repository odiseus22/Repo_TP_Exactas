/* ** por compatibilidad se omiten tildes **
================================================================================
 TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
================================================================================
  definicion de estructuras para administrar tareas
*/

#define DIRECCION_TAREA_IDLE 0x0001A000


#include "tss.h"
#include "task.h"

uint32_t direccionesCronenberg[24]; 
uint32_t posActualTareas[24];  //lo tuve que poner aca por problemas con los defines =(
uint32_t posAnteriorTareas[24];
uint32_t posPortal[4];    // 0 ,1= Rc137,Mc137 , 2,3=d248
uint32_t posPortalOld[4];
uint32_t contadorPuntos[2];		// 0= rickC137, 1=rickD248


tss tss_initial;

tss tss_idle = (tss) {
.eip = DIRECCION_TAREA_IDLE,
.cr3 = KERNEL_PAGE_DIR,      // es el mismo cr3 que el kernel
.esp = 0x27000,              // PILA DEL KERNEL
.cs = GDT_OFF_CS_RING_0,
.ds = GDT_OFF_DS_RING_0,
.es = GDT_OFF_DS_RING_0,
.fs = GDT_OFF_DS_RING_0,
.gs = GDT_OFF_DS_RING_0,
.ss = GDT_OFF_DS_RING_0,
.eflags = 0x202,
.iomap = 0xffff,
};

// funcion auxiliar para que llene la base del descriptor de la TSS
void setTSSdescriptor(uint32_t indexGDT, uint32_t dirTss){
	
gdt[indexGDT].base_0_15 = dirTss;
gdt[indexGDT].base_23_16 = dirTss >> 16;
gdt[indexGDT].base_31_24 = dirTss >> 24;
}




//necesito: ubicacion de cada tarea, quien es cada tarea
//orden de tareas: rick 137, morty 137, rick 248, morty 248 y 20 tareas cronenberg
//uint32_t direccionesCronenberg[24];

void tss_init() {

setTSSdescriptor(GDT_TAREA_INICIAL, (uint32_t) &tss_initial );

setTSSdescriptor(GDT_TAREA_IDLE, (uint32_t) &tss_idle );

for (int i = 0; i < 24; i++){
	uint8_t x = 0;
	uint8_t y = 0;
	getRandomPosition(i,&x,&y);
	uint32_t posFinal = 0x400000 + x * 0x2000 + y * 0x2000 * 80;
	direccionesCronenberg[i] = posFinal;
	posActualTareas[i]=posFinal;
	posAnteriorTareas[i]=posFinal;
	
	
}
tss_initCronenberg(&direccionesCronenberg[0]);

}





/* Completa la tss de una tarea, r           */
void fillTSS(uint32_t indexGDT, uint32_t task_address, uint32_t cronenberg_address){
	
   // uint32_t indexGDT = selector >> 3;

    uint32_t dirTss = 0;
    dirTss += gdt[indexGDT].base_31_24;
    dirTss =  dirTss << 8;
    dirTss += gdt[indexGDT].base_23_16;
    dirTss =  dirTss << 16;
    dirTss += gdt[indexGDT].base_0_15;
    

    tss* tss_tarea = (tss*) dirTss;


	
    tss_tarea->eip = (uint32_t) TASK_CODE;
    tss_tarea->esp = (uint32_t) (TASK_CODE+(PAGE_SIZE*2));  //-1?
	tss_tarea->ebp = (uint32_t) (TASK_CODE+(PAGE_SIZE*2));
	tss_tarea->cs = GDT_OFF_CS_RING_3 +3; //dpl = 11
	tss_tarea->ds = GDT_OFF_DS_RING_3 +3;  
	tss_tarea->es = GDT_OFF_DS_RING_3 +3;
	tss_tarea->fs = GDT_OFF_DS_RING_3 +3;
	tss_tarea->gs = GDT_OFF_DS_RING_3 +3;
	tss_tarea->ss = GDT_OFF_DS_RING_3 +3;
	tss_tarea->eflags= 0x202; 		//interrupciones activadas
	tss_tarea->iomap = 0xffff;
	uint32_t nuevaPag= mmu_nextFreeKernelPage();
	tss_tarea->esp0 = nuevaPag + PAGE_SIZE; //-1?
	tss_tarea->ss0=GDT_OFF_DS_RING_0;
	
	tss_tarea->cr3 = mmu_initTaskDir(cronenberg_address,task_address);

}




tss tss_rickC137;
tss tss_mortyC137;
tss tss_rickD248;
tss tss_mortyD248;
tss tss_cronenberg1;
tss tss_cronenberg2;
tss tss_cronenberg3;
tss tss_cronenberg4;
tss tss_cronenberg5;
tss tss_cronenberg6;
tss tss_cronenberg7;
tss tss_cronenberg8;
tss tss_cronenberg9;
tss tss_cronenberg10;
tss tss_cronenberg11;
tss tss_cronenberg12;
tss tss_cronenberg13;
tss tss_cronenberg14;
tss tss_cronenberg15;
tss tss_cronenberg16;
tss tss_cronenberg17;
tss tss_cronenberg18;
tss tss_cronenberg19;
tss tss_cronenberg20;

tss* arregloCronenbergs[20]={&tss_cronenberg1,
&tss_cronenberg2,&tss_cronenberg3,&tss_cronenberg4,&tss_cronenberg5,&tss_cronenberg6,&tss_cronenberg7,&tss_cronenberg8,&tss_cronenberg9,&tss_cronenberg10,&tss_cronenberg11,&tss_cronenberg12,&tss_cronenberg13
,&tss_cronenberg14,&tss_cronenberg15,&tss_cronenberg16,&tss_cronenberg17,&tss_cronenberg18,&tss_cronenberg19,&tss_cronenberg20};

/*	para todas las tareas que no sean la idle y init,
	lo que hace es completar su descriptor de tss y 
	luego llena correctamente su tss	*/

void tss_initCronenberg(uint32_t* direccionesCronen){
	//uint32_t direccionMundoCronenberg=0;
	for  (int i = 0; i < 20; i++)
	{
		//if(i ==15) //breakpoint();
    gdt[i+19].limit_0_15 = 0x0067,		
    gdt[i+19].base_0_15 = 0x0000,                   
    gdt[i+19].base_23_16 = 0x00,
    gdt[i+19].type = 9,		//ts con b=0
    gdt[i+19].s = 0,
    gdt[i+19].dpl = 0x00,		// PROTECCION NIVEL supersivor
    gdt[i+19].p = 1,			//presente
    gdt[i+19].limit_16_19 = 0x00,
    gdt[i+19].avl = 0x00,
    gdt[i+19].l = 0x00,
    gdt[i+19].db = 0,			//0 si es tss descriptor segun manual
    gdt[i+19].g = 0, 			//granularidad de bytes
    gdt[i+19].base_31_24 = 0x00,
    
	setTSSdescriptor((i+19) , (uint32_t) arregloCronenbergs[i] );
	//breakpoint();                
	fillTSS( i+19 ,0x18000, direccionesCronen[i+4] );	//las primeras 4 son para los ricks y mortys
	}
	
	
	/* Ricks and mortys */

	setTSSdescriptor(GDT_TAREA_RICK_C137, (uint32_t) &tss_rickC137 );
	setTSSdescriptor(GDT_TAREA_MORTY_C137, (uint32_t) &tss_mortyC137 );
	setTSSdescriptor(GDT_TAREA_RICK_D248, (uint32_t) &tss_rickD248 );
	setTSSdescriptor(GDT_TAREA_MORTY_D248, (uint32_t) &tss_mortyD248 );


	fillTSS(((15)),0x10000, direccionesCronen[0] );
	fillTSS(((16)),0x12000, direccionesCronen[1] );
	fillTSS(((17)),0x14000, direccionesCronen[2] );
	fillTSS(((18)),0x16000, direccionesCronen[3] );



}


