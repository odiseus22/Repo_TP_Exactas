/* ** por compatibilidad se omiten tildes **
================================================================================
 TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
================================================================================
  definicion de funciones del manejador de memoria
*/

#include "mmu.h"

uint32_t proxima_pagina_libre;

void mmu_init() {
    proxima_pagina_libre = INICIO_DE_PAGINAS_LIBRES;
}

void mmu_zerosPage(uint32_t *entry){
    for (int i = 0; i < 1024; i++)
    {
        *(entry+i)=0;
    }
    
}

uint32_t mmu_nextFreeKernelPage() {
    uint32_t pagina_libre=proxima_pagina_libre;
    proxima_pagina_libre += PAGE_SIZE;
    return pagina_libre;
}
/*
void mmu_mapPage(uint32_t cr3, uint32_t virtual, uint32_t phy, uint32_t attrs) {
    //limpiar cr3
    uint32_t directoryIdx = virtual >> 22;
    uint32_t tableIdx = (virtual >> 12) & 0x3FF ;
//eze consultas
//esta funcion ARREGLA EL CONTENIDO DE LAS TABLAS
//PARA QUE AL USAR LA DIRECCION VIRTUAL TE LLEVE A LA DIRECCION FISICA


                         //cre3 donde esta descriptor de tabla virtual=direcciones de las tablas   phy=direccion fisica
void mmu_mapPage(uint32_t cr3, uint32_t virtual, uint32_t phy, uint32_t attrs) {
	                                                            //ATTRS ES MASCARA DE BITS
	                                                            //TE DICE QUE ATRIBUTOS DEBEN ESTAR EN 1
// los ultimos 3 DIGITOS EN HEXA DE VIRTUAL Y PHY COINCIDEN SIEMPRE
// VIRTUAL 0X00805123 ->  FISICA 0X10123	
    uint32_t directoryIdx = virtual >> 22; //SHIFTEAMOS A DERECHA NOS QUEDAMOS CN LO QUE NOS SIRVE
    uint32_t tableIdx = (virtual >> 12) & 0x3FF ; //obtengo indices directorio , ME QUEDO SOLO CON LOS DEL MEDIO // y tabla
            //PODRIA SHIFTEAR    (VIRTUAL <<10) >> 22 PARA HACER LO MISMO                       
    
	uint32_t *PDE_ptr = (uint32_t*) cr3[directoryIdx];   // es lo mismo hacer cr3+directoryIdx

	uint32_t noHayQueCrearPT = *PDE_ptr & 0x00000001;
	if( noHayQueCrearPT == 0 ){
	uint32_t presentePT = *PDE_ptr & 0x00000001;
	if( presentePT == 0 ){   //si la tabla no estaba presente hay que hacerla presente
		uint32_t newPT = mmu_nextFreeKernelPage();
		mmu_zerosPage((uint32_t*) newPT);

		*PDE_ptr = newPT | attrs;
	}                                      //es un not del numero de la derecha
	uint32_t *PT = (uint32_t*) (*PDE_ptr & ~ 0xFFF);
	*(PT+tableIdx) =  (phy & ~ 0xFFF) | attrs;
	tlbflush();
}
*/
void mmu_mapPage(uint32_t cr3, uint32_t virtual, uint32_t phy, uint8_t rw, uint8_t us) {
    
    uint32_t directoryIdx = virtual >> 22;
    uint32_t tableIdx = (virtual >> 12) & 0x3FF ; 
    
	page_directory_entry *PD = (page_directory_entry*) (( cr3 >> 12 ) << 12);   //limpiamos bits menos significativos de cr3

	uint32_t presente = PD[directoryIdx].present;
	if( presente == 0 ){
        
		page_table_entry *newPT = (page_table_entry*) mmu_nextFreeKernelPage();
        
		mmu_zerosPage( (uint32_t*) newPT);
        
		PD[directoryIdx].page_table_base = (uint32_t) newPT >> 12;
        PD[directoryIdx].user_supervisor=1;    //ponemos siempre usuario y r/w para que siempre se pueda acceder
        PD[directoryIdx].read_write=1;          // y luego dependa de la page table entry
        PD[directoryIdx].present=1;
	}
        

    page_table_entry *PT = (page_table_entry*) (PD[directoryIdx].page_table_base << 12);
    PT[tableIdx].physical_address_base = phy >> 12;  //paso solo los bits mas significativos
    PT[tableIdx].user_supervisor=us;
    PT[tableIdx].read_write=rw;
    PT[tableIdx].present=1;
	tlbflush();
}

	 //cache buffer de las direcciones virtuales se vacia
 //es LENTISIMO resolver direcciones sin la tlb, traducir todo, chequear permisos
//la tenemos que limpiar  para que no lea las cosas viejas sin modificar
//por SIMPLICIDAD BORRAMOS TODA LA TLB

uint32_t mmu_unmapPage(uint32_t cr3, uint32_t virtual) {
    uint32_t directoryIdx = virtual >> 22;
    uint32_t tableIdx = (virtual >> 12) & 0x3FF ;  
    
	uint32_t *PDE_ptr = (uint32_t*) cr3+directoryIdx;
    uint32_t *PT = (uint32_t*) (*PDE_ptr & ~ 0xFFF);

    *(PT+tableIdx)=0x0000000000000000;
    
	tlbflush();
    return (uint32_t) (PT+tableIdx);
}
/*
uint32_t mmu_initKernelDir() {
    uint32_t *pd = (uint32_t*) KERNEL_PAGE_DIR;
    uint32_t *pt = (uint32_t*) KERNEL_PAGE_TABLE_0;

   

    *pd= (uint32_t) pt |PAG_S| PAG_RW | PAG_P;     //ESTO DEJA EN LA TABLA 1(PAGE DIRECTORY) LA DIREC DE LA TABLA 2(PAGE TABLE) Y EN LOS  3 BITS MENOS SIGN PONE UN 3

    for (uint32_t i = 0; i < 1024; i++)     //1024 PAGINAS DE 4K EN TOTAL 4 MEGAS
    {
       uint32_t *ptrPTE = pt+i;
       *ptrPTE = (i<<12) |PAG_S| PAG_RW | PAG_P;    //CREAMOS MUCHAS PAGINAS EN LA TABLITA 2(PAGE TABLE)
    }
    
    return (uint32_t) pd;
}
*/


uint32_t mmu_initKernelDir() {
    page_directory_entry *pd = (page_directory_entry *) KERNEL_PAGE_DIR;
    page_table_entry *pt = (page_table_entry *) KERNEL_PAGE_TABLE_0;


    pd[0].present = MMU_FLAG_PRESENT; 
    pd[0].user_supervisor = MMU_FLAG_USER;
    pd[0].read_write = MMU_FLAG_READWRITE;
    pd[0].page_table_base = (uint32_t) pt >> 12 ;
    

    for (uint32_t i = 0; i < 1024; i++)     //1024 PAGINAS DE 4K EN TOTAL 4 MEGAS
    {
    pt[i].present = MMU_FLAG_PRESENT; 
    pt[i].user_supervisor = MMU_FLAG_SUPERVISOR;
    pt[i].read_write = MMU_FLAG_READWRITE;
    pt[i].physical_address_base = i  ;
    }
    
    return (uint32_t) pd;
}



//inicializa direcciones para tarea
uint32_t mmu_initTaskDir(uint32_t direccionFisica , uint32_t tareaOriginalVirtual){  //direccion fisica: destino en la cual guardaremos la instancia de el codigo asignado a nuestra tarea
   
    page_directory_entry *pd = (page_directory_entry*) mmu_nextFreeKernelPage();      //TareaOriginalVirtual  ubicacion de codigo en el kernel que se copiara a la tarea
    mmu_zerosPage((uint32_t*)pd);
    
    //mapeo el kernel
    for (int i = 0; i < 1024; i++){
        uint32_t virtual=i*PAGE_SIZE;
        uint32_t fisica=i*PAGE_SIZE;
        if(i==983) {
       
        //lcr3((uint32_t)pd);
        } 

         mmu_mapPage((uint32_t) pd,virtual,fisica,MMU_FLAG_READWRITE,MMU_FLAG_SUPERVISOR);     //mapea con identity mapping de 0 a 4mb (0x400000)
    }
     
    //mapeamos la pos 0x08000000(todas las tareas usan esta direcc en su contexto) al mundo crononeberg, 
    mmu_mapPage((uint32_t)pd, direccionTarea,direccionFisica,MMU_FLAG_READWRITE,MMU_FLAG_USER); 
    mmu_mapPage((uint32_t)pd, direccionTarea+PAGE_SIZE, direccionFisica+PAGE_SIZE ,MMU_FLAG_READWRITE, MMU_FLAG_USER);
    
    //hacemos el mapeo de identity del mundo crononberg de la tarea AUXILIAR en el cr3 del kernel (el directory page del kernel y no de la tarea)
                         
    mmu_mapPage(rcr3(), direccionFisica, direccionFisica,MMU_FLAG_READWRITE,MMU_FLAG_SUPERVISOR);                         //hacemos esto para poder copiar la tarea
    mmu_mapPage(rcr3(), direccionFisica+PAGE_SIZE , direccionFisica+PAGE_SIZE ,MMU_FLAG_READWRITE, MMU_FLAG_SUPERVISOR);  // del kernel hacia donde queremos realmente
    
    //copiamos tarea del kernel al mundo cronenberg

    uint8_t* src = (uint8_t*) tareaOriginalVirtual;
    uint8_t* dst = (uint8_t*) direccionFisica; //podemos hacer esto ya que direccion fisica, enrrealidad es una direccion lineal mapeada con identity mapping

    for (int i = 0; i < PAGE_SIZE*2; i++)
    {
        dst[i]=src[i];
    }
    
    mmu_unmapPage(rcr3(),direccionFisica); //quitamos el identity mapping auxiliar
    mmu_unmapPage(rcr3(),direccionFisica+PAGE_SIZE);

    return (uint32_t) pd;
}
