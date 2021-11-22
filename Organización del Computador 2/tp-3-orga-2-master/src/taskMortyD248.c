/* ** por compatibilidad se omiten tildes **
================================================================================
 TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
================================================================================
*/

#include "syscall.h" 

void task() {
    
    while(1) {
        //breakpoint();
        syscall_usePortalGun(4, 0, 1, 0);
    };
}
