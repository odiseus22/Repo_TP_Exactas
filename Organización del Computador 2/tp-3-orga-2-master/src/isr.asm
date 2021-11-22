; ** por compatibilidad se omiten tildes **
; ==============================================================================
; TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
; ==============================================================================
; definicion de rutinas de atencion de interrupciones

%include "print.mac"
extern print_interrupt
extern printScanCode
extern whereIsMortyAux
extern usePortalGun
extern iAmRickAux
extern imprimirJugadores
extern usadoPortalRickDispMorty
extern endGameExepcion
extern modoDebugOn
extern estoyEnExepcionModoDebug
extern imprimirDebug
extern matarTarea
extern calcTareasMuertas
global matarTareaAux
BITS 32

sched_task_offset:     dd 0xFFFFFFFF
sched_task_selector:   dw 0xFFFF
resPortalGun: dd 0x00000000
whereIsMortyX: dd 0x00000000
whereIsMortyY: dd 0x00000000
i_rm_msg db     'Se ha producido una interrupcion numero : '
i_rm_len equ    $ - i_rm_msg

;; PIC
extern pic_finish1

;; Sched
extern sched_nextTask

extern print_dec
;;
;; Definición de MACROS
;; -------------------------------------------------------------------------- ;;

%macro ISR 1
global _isr%1

_isr%1:
    pushad
 


    cmp byte [modoDebugOn], 1
    je .hacerCosas
.volver:
    str cx
    shr cx, 3

    cmp cx, 18      ; si el indice es menor o igual a 18 entonces fue una task rick,morty -> endGame
    jg .finI
    cmp cx, 15
    jl .finI

    str ax
    push ax
    call endGameExepcion

.finI:
    sub cx, 15
    push cx
    call matarTarea
    pop cx
.fin:
    popad
    iret




.hacerCosas:
             mov eax, %1     ;imprimimos interrupcion
             push eax
             call print_interrupt
             pop eax

            mov dword [estoyEnExepcionModoDebug], 1
            push ebp
            mov ebp, esp
            add ebp, 4
            push dword [ebp]          ;edi
            push dword [ebp+4]        ;esi
            push dword [ebp+8]        ;ebp
            push dword [ebp+16]       ;ebx (el esp estaba rancio)
            push dword [ebp+20]       ;edx
            push dword [ebp+24]       ;ecx
            push dword [ebp+28]       ;eax
            push dword [ebp+36]       ;eip (me salteo error code)
            push dword [ebp+40]       ;cs
            push dword [ebp+44]       ;eflags
            push dword [ebp+48]       ;esp
            push dword [ebp+52]       ;ss

            call imprimirDebug
            sub esp, (12*8)
            pop ebp

            ;jmp 0x70:0           ;tarea idle
            jmp .volver
            

%endmacro

;; Rutina de atención de las EXCEPCIONES
;; -------------------------------------------------------------------------- ;;
ISR 0
ISR 1
ISR 2
ISR 3
ISR 4
ISR 5
ISR 6
ISR 7
ISR 8
ISR 9
ISR 10
ISR 11
ISR 12
ISR 13
ISR 14
ISR 15
ISR 16
ISR 17
ISR 18
ISR 19



;; Rutina de atención del RELOJ
;; -------------------------------------------------------------------------- ;;
global _isr32
_isr32:
        pushad
         
        call pic_finish1
        ;xchg bx,bx
        cmp dword [estoyEnExepcionModoDebug], 1
        je .fin

        call resetearPortalesRick
        call imprimirJugadores
        call calcTareasMuertas
        call sched_nextTask
        str cx
        cmp ax, cx
        je .fin
        mov [sched_task_selector], ax
        jmp far [sched_task_offset]
        .fin:
        popad
        iret
;; Rutina de atención del TECLADO
;; -------------------------------------------------------------------------- ;;
global _isr33
_isr33:
        pushad
        in al, 0x60     ; se lee la tecla
        xor ecx, ecx
        or cl,al        ; la tecla queda en cl con todo lo demas limpio
        mov bl, cl      ; copia de cl en bl
        push ecx
        call printScanCode



        pop ecx
        call pic_finish1
        popad
        iret
;; Rutinas de atención de las SYSCALLS
;; -------------------------------------------------------------------------- ;;
global _isr137
_isr137:
        pushad
        push edx
        push ecx
        push ebx
        push eax
        ;xchg bx, bx 
        call usePortalGun
        mov [resPortalGun], eax
        add esp, 16
        popad
        mov eax, [resPortalGun]
        iret

global _isr138
_isr138:
        pushad
        push eax
        call iAmRickAux
        pop eax
        popad
        iret

global _isr139
_isr139:
        pushad                                         ;esto VA A EXPLOTAR CLAVEEE EZE AYUDAAAAAAAA
        
        lea ebx, [whereIsMortyY]
        push ebx
        lea eax, [whereIsMortyX]
        push eax
        ;sub esp, 8  ;reservo 2 numeros de 32
        call whereIsMortyAux  ;dondeEstoy(x,y)
        add esp, 8

        popad
        mov eax, [whereIsMortyX]
        mov ebx, [whereIsMortyY]
        iret


;; Funciones Auxiliares
;; -------------------------------------------------------------------------- ;;
isrNumber:           dd 0x00000000
isrClock:            db '|/-\'
nextClock:
        pushad
        inc DWORD [isrNumber]
        mov ebx, [isrNumber]
        cmp ebx, 0x4
        jl .ok
                mov DWORD [isrNumber], 0x0
                mov ebx, 0
        .ok:
                add ebx, isrClock
                print_text_pm ebx, 1, 0x0f, 49, 79
                popad
        ret



matarTareaAux:
        jmp 0x70:0


resetearPortalesRick:push ebp
                     mov ebp, esp
                     mov dword [usadoPortalRickDispMorty], 0
                     mov dword [usadoPortalRickDispMorty+8], 0
                     pop ebp
                     ret