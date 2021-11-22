; ** por compatibilidad se omiten tildes **
; ==============================================================================
; TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
; ==============================================================================

%include "print.mac"
extern GDT_DESC
extern idt_init
extern IDT_DESC
extern pic_reset
extern pic_enable
extern mmu_initKernelDir
extern mmu_init
extern libretas
extern tss_init
extern tss_iddle_init
extern mmu_initTaskDir
extern fillTSS
extern game_init
extern sched_init
extern screen_init
extern imprimirGilada
global start

%define CS_RING_0 (8<<3)
%define DS_RING_0 (9<<3)
%define VIDEO_SELECTOR (12<<3)
;; Saltear seccion de datos
jmp start

;;
;; Seccion de datos.
;; -------------------------------------------------------------------------- ;;
start_rm_msg db     'Iniciando kernel en Modo Real'
start_rm_len equ    $ - start_rm_msg

start_pm_msg db     'Iniciando kernel en Modo Protegido'
start_pm_len equ    $ - start_pm_msg

;;
;; Seccion de código.
;; -------------------------------------------------------------------------- ;;

;; Punto de entrada del kernel.
BITS 16
start:
    ; Deshabilitar interrupciones
    cli

    ; Cambiar modo de video a 80 X 50
    mov ax, 0003h
    int 10h ; set mode 03h
    xor bx, bx
    mov ax, 1112h
    int 10h ; load 8x8 font

    ; Imprimir mensaje de bienvenida
    print_text_rm start_rm_msg, start_rm_len, 0x07, 0, 0
    
    ;breakpoint
    ;xchg bx, bx 

    ; Habilitar A20
    call A20_disable
    call A20_check
    call A20_enable
    call A20_check
    
    ; Cargar la GDT
    LGDT [GDT_DESC]

    ; Setear el bit PE del registro CR0
    mov eax, CR0
    or eax, 0x01
    mov CR0, eax

    ; Saltar a modo protegido
    ;jmp far
    jmp CS_RING_0:modo_protegido

    BITS 32
    modo_protegido:

    ; Establecer selectores de segmentos
    mov ax, DS_RING_0
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax          

    ; Establecer la base de la pila
    mov esp, 0x27000
    mov ebp, 0x27000

    ; Imprimir mensaje de bienvenida
    mov ax, VIDEO_SELECTOR
    mov es, ax

    ; Inicializar pantalla
    call screen_init

    ; Inicializar el manejador de memoria
    call mmu_init
    
    ; Inicializar el directorio de paginas
    call mmu_initKernelDir
    
    ; Cargar directorio de paginas
    mov CR3, eax

    ; Habilitar paginacion
    mov eax, CR0
    or eax, 0x80000000                                   ;pae=1
    mov CR0, eax


    ;Inicializar la IDT
    call idt_init

    ; Cargar IDT
    LIDT [IDT_DESC]
     
    ; Configurar controlador de interrupciones
    call pic_reset
    call pic_enable
     

  ;uint32_t mmu_initTaskDir(uint32_t direccionFisica , uint32_t tareaOriginalVirtual);
  ;prueba INICIO                                ;
    ;xchg bx,bx                                 ;
    ;push 0x0001A000                            ;codigo idle
    ;push 0x401000                              ; direccion cronenbergbase+0x1000
    ;push (14 << 3)
    ;call mmu_initTaskDir                       ; RECORDAR COMENTAR, ESTO ES PARA DEBUGEAR
    ;call fillTSS
    ;xchg bx,bx                                 ;
    ;add esp, 4*2                               ;
    ;mov cr3, eax                               ; Basicamente provamos como funcionan las tareas usando idle como una tarea de debug
    ;jmp 0x08000000                             ;
  ;prueba FIN
   

  ;Inicializar tss
  call tss_init

  ;Inicializar tss de la tarea Idle
    
   
  ;Inicializar el scheduler
  call sched_init

  ;Cargar tarea inicial

  ;Habilitar interrupciones
  ;sti
  ;xchg bx, bx
  call game_init
  ; Saltar a la primera tarea: Idle
  mov ax, (13 << 3)               ;  selector de la tarea inicial en la gdt (indice 13)
  ltr ax  
  jmp 0x70:0                      ; revisar (indice 14 shifteado 3)

  ; Ciclar infinitamente (por si algo sale mal...)
  mov eax, 0xFFFF
  mov ebx, 0xFFFF
  mov ecx, 0xFFFF
  mov edx, 0xFFFF
    
  call libretas; //funcion poner libretas de un ejercicio
  jmp $

;; -------------------------------------------------------------------------- ;;

%include "a20.asm"




















