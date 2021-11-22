/* ** por compatibilidad se omiten tildes **
================================================================================
 TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
================================================================================

    Definiciones globales del sistema.
*/

#ifndef __DEFINES_H__
#define __DEFINES_H__

/* Bool */
/* -------------------------------------------------------------------------- */
#define TRUE                    0x00000001
#define FALSE                   0x00000000
#define ERROR                   1

/* Atributos paginas */
/* -------------------------------------------------------------------------- */
#define PAG_P                   0x00000001
#define PAG_R                   0x00000000
#define PAG_RW                  0x00000002
#define PAG_S                   0x00000000
#define PAG_US                  0x00000004

/* Misc */
/* -------------------------------------------------------------------------- */
#define SIZE_N                  40 // X
#define SIZE_M                  80 // Y
#define MAX_CANTIDAD_PUNTOS 20

/* Indices en la gdt */
/* -------------------------------------------------------------------------- */
#define GDT_COUNT 41

#define GDT_IDX_NULL_DESC           0
#define GDT_IDX_CS_RING_0           8
#define GDT_IDX_DS_RING_0           9
#define GDT_IDX_CS_RING_3           10
#define GDT_IDX_DS_RING_3           11
#define GDT_IDX_VIDEO               12

#define GDT_TAREA_INICIAL           13
#define GDT_TAREA_IDLE              14

#define GDT_TAREA_RICK_C137         15
#define GDT_TAREA_MORTY_C137        16
#define GDT_TAREA_RICK_D248         17
#define GDT_TAREA_MORTY_D248        18

#define GDT_TAREA_CRONENBERG(numero)   18+numero
/* Offsets en la gdt */
/* -------------------------------------------------------------------------- */  
//estos son los numeros que indican cada segmento, los que se usan en jmp [numerosegmento:offset dentro del segmento]
#define GDT_OFF_NULL_DESC           (GDT_IDX_NULL_DESC << 3)
#define GDT_OFF_CS_RING_0           (GDT_IDX_CS_RING_0 << 3)
#define GDT_OFF_CS_RING_3           (GDT_IDX_CS_RING_3 << 3)
#define GDT_OFF_DS_RING_0           (GDT_IDX_DS_RING_0 << 3)
#define GDT_OFF_DS_RING_3           (GDT_IDX_DS_RING_3 << 3)
#define GDT_OFF_TAREA_CRONENBERG(numero)           ( (GDT_TAREA_CRONENBERG(numero) ) << 3)
#define GDT_OFF_TAREA_RICK_C137      (GDT_TAREA_RICK_C137 << 3)       
#define GDT_OFF_TAREA_MORTY_C137     (GDT_TAREA_MORTY_C137 << 3)
#define GDT_OFF_TAREA_RICK_D248      (GDT_TAREA_RICK_D248 << 3)
#define GDT_OFF_TAREA_MORTY_D248     (GDT_TAREA_MORTY_D248 <<3)


/* Selectores de segmentos */
/* -------------------------------------------------------------------------- */

/* Direcciones de memoria */
/* -------------------------------------------------------------------------- */
#define BOOTSECTOR               0x00001000 /* direccion fisica de comienzo del bootsector (copiado) */
#define KERNEL                   0x00001200 /* direccion fisica de comienzo del kernel */
#define VIDEO                    0x000B8000 /* direccion fisica del buffer de video */

/* Flags MMU */
/* -------------------------------------------------------------------------- */

#define MMU_FLAG_PRESENT 1
#define MMU_FLAG_SUPERVISOR 0
#define MMU_FLAG_USER   1
#define MMU_FLAG_READWRITE 1

/* Direcciones virtuales de código, pila y datos */
/* -------------------------------------------------------------------------- */
#define TASK_CODE             0x08000000 /* direccion virtual del codigo */

#define direccionTarea 0x08000000   //(virtual)

/* Direcciones fisicas de codigos */
/* -------------------------------------------------------------------------- */
/* En estas direcciones estan los códigos de todas las tareas. De aqui se
 * copiaran al destino indicado por TASK_<i>_CODE_ADDR.
 */

/* Direcciones fisicas de directorios y tablas de paginas del KERNEL */
/* -------------------------------------------------------------------------- */
#define KERNEL_PAGE_DIR          0x00027000
#define KERNEL_PAGE_TABLE_0      0x00028000
#define CRYSTALS_MAP             0x00029000
#define PAGE_SIZE                0x00001000
#define INICIO_DE_PAGINAS_LIBRES 0x100000
#endif  /* !__DEFINES_H__ */
