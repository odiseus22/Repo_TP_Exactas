/* ** por compatibilidad se omiten tildes **
================================================================================
 TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
================================================================================
  definicion de funciones del manejador de memoria
*/

#ifndef __MMU_H__
#define __MMU_H__

#include "stdint.h"
#include "defines.h"
#include "i386.h"
#include "tss.h"
#include "game.h"

typedef struct str_page_directory_entry
{
  uint8_t present:1;
  uint8_t read_write:1;
  uint8_t user_supervisor:1;
  uint8_t page_write_through:1;
  uint8_t page_cache_disable:1;
  uint8_t accessed:1;
  uint8_t x:1;
  uint8_t page_size:1;
  uint8_t ignored:1;
  uint8_t available:3;
  uint32_t page_table_base:20;
} __attribute__((__packed__ ,aligned (4))) page_directory_entry;

typedef struct str_page_table_entry
{
  uint8_t present:1;
  uint8_t read_write:1;
  uint8_t user_supervisor:1;
  uint8_t page_write_through:1;
  uint8_t page_cache_disable:1;
  uint8_t accessed:1;
  uint8_t dirty:1;
  uint8_t x:1;
  uint8_t global:1;
  uint8_t available:3;
  uint32_t physical_address_base:20;
}__attribute__((__packed__, aligned (4))) page_table_entry;



void mmu_init();

uint32_t mmu_nextFreeKernelPage();

void mmu_mapPage(uint32_t cr3, uint32_t virtual, uint32_t phy, uint8_t rw, uint8_t us);

uint32_t mmu_unmapPage(uint32_t cr3, uint32_t virtual);

uint32_t mmu_initKernelDir();

uint32_t mmu_nextFreeTaskPage();

void mmu_zerosPage(uint32_t *entry);

uint32_t mmu_initTaskDir(uint32_t direccionFisica , uint32_t tareaOriginalVirtual);





#endif	/* !__MMU_H__ */




