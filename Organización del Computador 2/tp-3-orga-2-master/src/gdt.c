/* ** por compatibilidad se omiten tildes **
================================================================================
 TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
================================================================================
  definicion de la tabla de descriptores globales
*/

#include "gdt.h"


gdt_entry gdt[GDT_COUNT] = {
    /* Descriptor nulo*/
    /* Offset = 0x00 */
    [GDT_IDX_NULL_DESC] = (gdt_entry) {
        (uint16_t)    0x0000,         /* limit[0:15]  */
        (uint16_t)    0x0000,         /* base[0:15]   */
        (uint8_t)     0x00,           /* base[23:16]  */
        (uint8_t)     0x00,           /* type         */
        (uint8_t)     0x00,           /* s            */
        (uint8_t)     0x00,           /* dpl          */
        (uint8_t)     0x00,           /* p            */
        (uint8_t)     0x00,           /* limit[16:19] */
        (uint8_t)     0x00,           /* avl          */
        (uint8_t)     0x00,           /* l            */
        (uint8_t)     0x00,           /* db           */
        (uint8_t)     0x00,           /* g            */
        (uint8_t)     0x00,           /* base[31:24]  */
    },
    /* Descriptor CODIGO LEVEL 0*/
    [GDT_IDX_CS_RING_0] = (gdt_entry) {
    .limit_0_15 = 0x88ff,		    //137mb
    .base_0_15 = 0x0000,
    .base_23_16 = 0x00,
    .type = 10,		                // EXECUTABLE/READ
    .s = 0x01,              	    // SEGMENTO DE CODIGO/DATA 
    .dpl = 0x00,		            // PROTECCION NIVEL 0
    .p = 1,			                //presente
    .limit_16_19 = 0x00,
    .avl = 0x00,
    .l = 0x00,
    .db = 1,		                //modo 32 bits
    .g = 1, 			            //granularidad de 4kb
    .base_31_24 = 0x00,
    },
    /* Descriptor DATA LEVEL 0*/
    [GDT_IDX_DS_RING_0] = (gdt_entry) {
    .limit_0_15 = 0x88ff,		       //137mb
    .base_0_15 = 0x0000,
    .base_23_16 = 0x00,
    .type = 2,		                    //READ/WRITE
    .s = 0x01,
    .dpl = 0x00,		                // PROTECCION NIVEL 0
    .p = 1,			                    //presente
    .limit_16_19 = 0x00,
    .avl = 0x00,
    .l = 0x00,
    .db = 1,			                //modo 32 bits
    .g = 1, 			                //granularidad de 4kb
    .base_31_24 = 0x00,
    },
    /* Descriptor CODIGO LEVEL 1*/
   [GDT_IDX_CS_RING_3] = (gdt_entry) {
    .limit_0_15 = 0x88ff,		           //137mb
    .base_0_15 = 0x0000,
    .base_23_16 = 0x00,
    .type = 10,	                            // EXECUTABLE/READ
    .s = 0x01,
    .dpl = 0x03,		                    // PROTECCION NIVEL USUARIO
    .p = 1,			                        //presente
    .limit_16_19 = 0x00,
    .avl = 0x00,
    .l = 0x00,
    .db = 1,		                    	//modo 32 bits
    .g = 1, 			                    //granularidad de 4kb
    .base_31_24 = 0x00,
    },
    /* Descriptor DATA LEVEL 1*/
   [GDT_IDX_DS_RING_3] = (gdt_entry) {
    .limit_0_15 = 0x88ff,		            //137mb
    .base_0_15 = 0x0000,
    .base_23_16 = 0x00,
    .type = 2,			                    //READ/WRITE
    .s = 0x01,
    .dpl = 0x03,			                //PROTECCION NIVEL 3
    .p = 1,			                        //presente
    .limit_16_19 = 0x00,
    .avl = 0x00,
    .l = 0x00,
    .db = 1,				                //modo 32 bits
    .g = 1, 				                //granularidad de 4kb
    .base_31_24 = 0x00,
    },

 [GDT_IDX_VIDEO] = (gdt_entry) {
    .limit_0_15 = 0x1f3f,		
    .base_0_15 = 0x8000,
    .base_23_16 = 0xB,
    .type = 2,		    	                //READ/WRITE
    .s = 0x01,
    .dpl = 0x00,			                // PROTECCION NIVEL 0
    .p = 1,				                    //presente
    .limit_16_19 = 0x00,
    .avl = 0x00,
    .l = 0x00,
    .db = 1,			    	            //modo 32 bits
    .g = 0, 				                //granularidad de bytes
    .base_31_24 = 0x00,
    }
,
[GDT_TAREA_INICIAL] = (gdt_entry) {
    .limit_0_15 = 0x0067,		
    .base_0_15 = 0x0000,                    // la base de la tarea inicial no me importa creo.
    .base_23_16 = 0x0,
    .type = 9,			                    //ts con b=0
    .s = 0,
    .dpl = 0x00,			                // PROTECCION NIVEL 0
    .p = 1,			                        //presente
    .limit_16_19 = 0x00,
    .avl = 0x00,
    .l = 0x00,
    .db = 0,			                    //0 si es tss descriptor segun manual
    .g = 0, 			                    //granularidad de bytes
    .base_31_24 = 0x00,
    }

,
[GDT_TAREA_IDLE] = (gdt_entry) {
    .limit_0_15 = 0x0067,		
    .base_0_15 = 0x0000,                    // falta obtener la direccion de la tss -> se arma una funcion
    .base_23_16 = 0x0,
    .type = 9,		                        //ts con b=0
    .s = 0,
    .dpl = 0x00,		                    // PROTECCION NIVEL SU
    .p = 1,				            	    //presente
    .limit_16_19 = 0x00,
    .avl = 0x00,
    .l = 0x00,
    .db = 0,			                    //0 si es tss descriptor segun manual
    .g = 0, 			                    //granularidad de bytes
    .base_31_24 = 0x00,
    },

[GDT_TAREA_RICK_C137] = (gdt_entry) {
    .limit_0_15 = 0x0067,		
    .base_0_15 = 0x0000,                   
    .base_23_16 = 0x10,
    .type = 9,  			                //ts con b=0
    .s = 0,
    .dpl = 0x00,		                    // PROTECCION NIVEL SU
    .p = 1,									//presente
    .limit_16_19 = 0x00,
    .avl = 0x00,
    .l = 0x00,
    .db = 0,								//0 si es tss descriptor segun manual
    .g = 0, 								//granularidad de bytes
    .base_31_24 = 0x00,
    },
[GDT_TAREA_MORTY_C137] = (gdt_entry) {
    .limit_0_15 = 0x0067,		
    .base_0_15 = 0x0000,                   
    .base_23_16 = 0x12,
    .type = 9,								//ts con b=0
    .s = 0,
    .dpl = 0x00,		                    // PROTECCION NIVEL SU
    .p = 1,				                    //presente
    .limit_16_19 = 0x00,
    .avl = 0x00,
    .l = 0x00,
    .db = 0,			                    //0 si es tss descriptor segun manual
    .g = 0, 			                    //granularidad de bytes
    .base_31_24 = 0x00,
    },
[GDT_TAREA_RICK_D248] = (gdt_entry) {
    .limit_0_15 = 0x0067,		
    .base_0_15 = 0x0000,                   
    .base_23_16 = 0x14,
    .type = 9,		                         //ts con b=0
    .s = 0,
    .dpl = 0x00,		                    // PROTECCION NIVEL SU
    .p = 1,			                         //presente
    .limit_16_19 = 0x00,
    .avl = 0x00,
    .l = 0x00,
    .db = 0,	                       		//0 si es tss descriptor segun manual
    .g = 0, 			                    //granularidad de bytes
    .base_31_24 = 0x00,
    },
[GDT_TAREA_MORTY_D248] = (gdt_entry) {
    .limit_0_15 = 0x0067,		
    .base_0_15 = 0x0000,                   
    .base_23_16 = 0x16,
    .type = 9,		                        //ts con b=0
    .s = 0,
    .dpl = 0x00,		                    // PROTECCION NIVEL SU
    .p = 1,			                        //presente
    .limit_16_19 = 0x00,
    .avl = 0x00,
    .l = 0x00,
    .db = 0,			                    //0 si es tss descriptor segun manual
    .g = 0, 			                    //granularidad de bytes
    .base_31_24 = 0x00,
    }

};
gdt_descriptor GDT_DESC = {
    sizeof(gdt) - 1,
    (uint32_t) &gdt
};
