/* ** por compatibilidad se omiten tildes **
================================================================================
 TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
================================================================================
  definicion de funciones del scheduler
*/

#ifndef __SCHED_H__
#define __SCHED_H__

#include "stdint.h"
#include "screen.h"


#include "gdt.h"

extern uint32_t tareasVivas[];
extern uint32_t CronenbergsOcupadas[];
extern void matarTareaAux();
void whereIsMortyAux(uint32_t* x,uint32_t* y);

void sched_init();
void matarTarea(uint32_t index);
int16_t sched_nextTask();

#endif	/* !__SCHED_H__ */
