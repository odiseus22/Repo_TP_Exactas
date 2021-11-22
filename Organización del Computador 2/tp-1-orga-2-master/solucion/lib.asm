
section .data

section .rodata
formato_printf_ptr db  '%p', 0
formato_printf_string db '%s', 0
formato_printf_printsorter db '%d = ', 0
ch_cerrar1 db ']', 0
ch_abrir1 db '[', 0
ch_coma db ',', 0 
nullString db 'NULL', 0
sig_linea db 10, 0
section .text

global strLen
global strClone
global strCmp
global strConcat
global strDelete
global strPrint
global listNew
global listAddFirst
global listAddLast
global listAdd
global listDelete
global listPrint
global listClone
global sorterNew
global sorterAdd
global sorterRemove
global sorterGetSlot
global sorterGetConcatSlot
global sorterCleanSlot
global sorterDelete
global sorterPrint
global fs_sizeModFive
global fs_firstChar
global fs_bitSplit
extern malloc
extern free
extern fprintf
extern listRemoveFirst
extern listRemove

;*** String ***

strLen:	push rbp
		mov rbp, rsp
		mov ecx, 0
		cmp rdi, 0
		je .fin
.ciclo:	cmp byte [rdi+rcx], 0
		je .fin
		inc ecx
		jmp .ciclo
.fin: 	mov eax, ecx
		pop rbp
		ret


; char* strClone(char* a)
strClone: push rbp
          mov rbp, rsp
          push rbx
          push r12
          mov rbx, rdi   ; rbx= char* a
         
	  	  call strLen    ;le pasamos el puntero al string y devuelve la longitud en rax
		  mov r12, rax	 ; r12 = string length
		  
		  mov rdi, rax
		  inc rdi        ; para poder definir el byte nulo al final del string
		  call malloc    ; le pasamos cuantos bytes queremos en rdi, devuelve un puntero en rax
		 
		  mov rsi, rbx	  ; seteo rdi, rsi para usar movsb
		  mov rdi, rax
		  mov r8, r12

.ciclo:	  cmp r8, 0
		  je .fin
		  cld
		  movsb			 ; [rdi]= [rsi] / rdi++,rsi++
		  dec r8
		  jmp .ciclo

.fin:	  mov byte [rdi], 0
		  mov rax, rdi
		  sub rax, r12

		  pop r12
		  pop rbx
		  pop rbp
		  ret




; int32_t strCmp(char* a, char* b)


strCmp:
; rdi<- char *a,   rsi<- char *b
	   push rbp
	   mov rbp, rsp
	   xor rdx, rdx
	   xor rcx, rcx
	   xor rax, rax
	   push r12
	   push r13
	   push r14
	   push r15

	   mov r12, rdi
	   mov r13, rsi

	   call strLen
	   mov r14, rax 		; r14 = lenght(a)

	   mov rdi, r13
	   call strLen 			; r15= lenght(b)
	   mov r15, rax

	   mov rsi, r13
	   mov rdi, r12

	   cmp byte [rdi], 0
	   je .esAnulo

	   cmp byte [rsi], 0
	   je .esBnulo

	   								; A   B
.ciclo:cmp byte [rdi], 0 			;     a
	   je .llegueNulo
	   cmp byte [rsi], 0
	   je .llegueNulo
	   ;cmp [ptrB], [ptrA]
	   mov byte cl, [rdi]
	   mov byte dl, [rsi]
	   cmp cl, dl
	   je .sonIguales
	   jl .esMenor
	   

.esMayor:
		mov eax, -1
		inc rsi
		inc rdi
		jmp .fin

.esMenor:
		mov eax, 1
		inc rsi
		inc rdi
		jmp .fin

.sonIguales:
		mov eax, 0
		inc rsi
		inc rdi
		jmp .ciclo

.esAnulo:
		mov byte cl, [rdi]
	    mov byte dl, [rsi]
	    cmp cl, dl
		mov eax, 1
		jmp .fin


.esBnulo:
	    mov byte cl, [rdi]
	    mov byte dl, [rsi]
	    cmp cl, dl
		mov eax, -1
		jmp .fin

.ambosNulos:
		mov eax, 0


.llegueNulo:
		cmp r14, r15
		jg .mayorLenght
		jl .menorLength

		mov eax, 0
		jmp .fin

.mayorLenght:
		mov eax, -1
		jmp .fin

.menorLength:
		mov eax, 1

.fin:   pop r15
		pop r14
		pop r13
		pop r12
		pop rbp
		ret



; char* strConcat(char* a, char* b)
;rdi <- *a   rdi<- *b
strConcat:
	push rbp
	mov rbp, rsp
	push rbx
	push r12
	push r13 ;sizeA
	push r14 ; sizeB
	push r15
	sub rsp, 8
	mov rbx, rdi ; rbx=*a
	mov r12, rsi  ; r12=*b

	; debo llamar a free

	; llamo a length con a
	call strLen
	mov r13, rax

	mov rdi, r12
	call strLen
	mov r14, rax

	; en rdi pongo length(a)+length(b)
	; incremento en uno para el 0 y llamo free

	mov rdi, r13
	add rdi, r14
	inc rdi

	call malloc
	; en rax tengo un ptr a la memoria 

	mov r8, r13
	mov rsi, rbx
	mov rdi, rax

.ciclo1:
	cmp r8, 0
	je .finCiclo1
	movsb			 ; [rdi]= [rsi] / rdi++,rsi++
	dec r8
	jmp .ciclo1

.finCiclo1:
	mov r8, r14
	mov rsi, r12

.ciclo2:
	cmp r8, 0
	je .fin
	movsb			 ; [rdi]= [rsi] / rdi++,rsi++
	dec r8
	jmp .ciclo2



.fin:
	mov r15, rdi   ; guardo donde termina el string copiado

	; ahora tengo que liberar la memoria

	mov rdi, rbx
	call free		; se rompe aca
	cmp rbx, r12
	je .terminar
	mov rdi, r12
	call free
.terminar:
	mov byte [r15], 0
	mov rax, r15 ; rax apunta al ultimo char, le restamos size
	sub rax, r13
	sub rax, r14
	add rsp, 8
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rbp
	ret


strDelete: push rbp
		   mov rbp, rsp
		   call free
		   pop rbp
		   ret


;void strPrint(char* a, FILE *pFile)(7 Inst.)
; rdi <- a*   , rsi<- FILE   ;rdx
strPrint:
	push rbp
	mov rbp, rsp

	cmp byte [rdi], 0
	jne .noNull


	mov rdi, rsi     
	mov rsi, formato_printf_string
	mov rdx, nullString
	jmp .print                  



.noNull:
	mov rcx, rdi  	; rcx<- rdi   ;variable temporal para el swap

	mov rdi, rsi
	mov rsi, formato_printf_string
	mov rdx, rcx  ;en rcx guarde char* a

.print:
	call fprintf              ;rdi<-archivo,rsi<-formato,rdx<-string
	pop rbp
	ret



;*** List ***

;typedef struct s_list{             posicion  tamaño=alineamiento     
;    struct s_listElem *first;      0-7       8
;    struct s_listElem *last;       8-15      8
;} list_t;                                    8*2=16 

;typedef struct s_listElem{         posicion   tamaño=alineamiento
;    void *data;                    0-7        8
;    struct s_listElem *next;       8-15       8
;    struct s_listElem *prev;       16-23      8
;} listElem_t;                                 8*3=24 bytes



;defines para listas y nodos
%define list_off_first 0
%define list_off_last  8
%define listElem_off_data  0
%define listElem_off_next 8
%define listElem_off_prev  16
%define listSize 16


;list_t* listNew()
listNew:
;inicio stack
push rbp
mov rbp, rsp
;codigo
mov rdi, 16    ;pido a malloc 16 bytes
call malloc   ;me devuelve puntero en rax, no necesito hacer nada mas    
mov qword [rax+list_off_first], 0
mov qword [rax+list_off_last], 0      
;fin stack
pop rbp
ret

;void listAddFirst(list_t* l, void* data)       rdi<-puntero lista l    rsi <- data* 
listAddFirst:
;inicio stack
push rbp
mov rbp, rsp
push rbx 
push r12        ;alineado a a 16 bytes
;guardo valores en registros preservados ya que llamare a malloc
mov rbx, rdi  ;rbx<-l*
mov r12, rsi  ;r12<-data*
;codigo 
mov rdi, 24
call malloc  ;rax <- puntero al nuevo primer nodo
;cargar data* en la direccion que otorgo malloc y le digo no tiene anterior
mov [rax+listElem_off_data], r12  
mov qword [rax+listElem_off_prev], 0   
;veo caso lista vacia osea primero=ultimo=0
cmp qword [rbx+list_off_first], 0   ;si uno de los 2 punteros es cero entonces lista vacia
je  .esVacia
;seguir si no es vacia

;al viejo primer elemento decirle decirle sos el segundo (actualizar punteros a anterior)
mov  rcx, [rbx+list_off_first]  ; rcx <-  puntero a primer elemento viejo
mov [rcx+listElem_off_prev], rax  ;actualizo anterior del viejo primero
;al nuevo le digo donde esta el segundo
mov [rax+listElem_off_next], rcx
;indicar a la lista quien es el primer elemento 
mov [rbx+list_off_first], rax
jmp .fin

.esVacia:
mov qword [rax+listElem_off_next], 0     
mov [rbx+list_off_first], rax
mov [rbx+list_off_last], rax

.fin:
;fin stack
pop r12
pop rbx
pop rbp
ret


listAddLast:
;void listAddlast(list_t* l, void* data)       rdi<-puntero lista l    rsi <- data* 

;inicio stack
push rbp
mov rbp, rsp
push rbx 
push r12        ;alineado a a 16 bytes
;guardo valores en registros preservados ya que llamare a malloc
mov rbx, rdi  ;rbx<-l*
mov r12, rsi  ;r12<-data*
;codigo 
mov rdi, 24
call malloc  ;rax <- puntero al nuevo ultimo nodo
;cargar data* en la direccion que otorgo malloc y le digo no tiene anterior
mov [rax+listElem_off_data], r12  
mov qword [rax+listElem_off_next], 0   
;veo caso lista vacia osea primero=ultimo=0
cmp qword [rbx+list_off_last], 0   ;si uno de los 2 punteros es cero entonces lista vacia
je  .esVacia
;seguir si no es vacia

;al viejo ultimo elemento decirle decirle sos el segundo (actualizar punteros a siguiente)
mov  rcx, [rbx+list_off_last]  ; rcx <-  puntero a ultimo elemento viejo
mov [rcx+listElem_off_next], rax  ;actualizo siguiente del viejo primero
;al nuevo le digo donde esta el ante ultimo
mov [rax+listElem_off_prev], rcx
;indicar a la lista quien es el ultimo elemento
mov [rbx+list_off_last], rax
jmp .fin

.esVacia:
mov qword [rax+listElem_off_prev], 0     
mov [rbx+list_off_first], rax
mov [rbx+list_off_last], rax

.fin:
;fin stack
pop r12
pop rbx
pop rbp
ret


listAdd:
;void listAdd(list_t* l, void* data, funcCmp_t* fc)          rdi<-l*  rsi<-data* rdx<-fc*
;como tengo un call en medio de mi funcion voy a necesitar conservar datos   en datos rbx, r12, r13
;inicio stack
push rbp
mov rbp, rsp
push rbx
push r12          
push r13      ;desalienado
push r14      ;usare r14 para guardar puntero actual
push r15      ;r15 para untero al siguiente
sub rsp, 8    ;alineado y con los registros reservados correctamente

;cambio registros a los registros que se preservan
mov rbx, rdi   ;rbx <- l*
mov r12, rsi   ;rsi <- data*
mov r13, rdx   ;rdx <- fc*


;actualizo los definiciones
%define data_ptr         r12
%define funcioncmp       r13
%define actual_ptr       r14
%define siguiente_ptr    r15

;codigo principal
 
;veo caso lista vacia osea primero=ultimo=0
cmp qword [rbx+list_off_first], 0   ;si uno de los 2 punteros es cero entonces lista vacia
je  .esVacia
;caso contrario seguir


;comparo data vs primero    , int funcion comparar (rdi, rsi)
mov actual_ptr, [rbx+list_off_first]
mov rdi, [actual_ptr+listElem_off_data]
mov rsi, data_ptr
call funcioncmp
cmp eax, 1
jl .agregarPrimero

;comparo data vs ultimo    , int funcion comparar (rdi, rsi)
mov actual_ptr, [rbx+list_off_last]
mov rdi, [actual_ptr+listElem_off_data]
mov rsi, data_ptr
call funcioncmp
cmp eax, -1
jg .agregarUltimo

;comparo con elementos que no son primeros ni ultimos , ademas se que hay 2 elementos o mas
mov actual_ptr, [rbx+list_off_first]
mov siguiente_ptr, [actual_ptr+listElem_off_next]

;a partir de aca rbx lo utilizo como registro para cuentas auxiliares (ya no lo uso como lista ya que se que no modificare el primero ni el ultimo)
xor rbx, rbx

.ciclo:
;guarda del ciclo
 
; comparo con el siguiente (se que el anterior o es el primero o pregunte lo mismo y el dato a insertar es mas grande que estos anteriores)
mov rdi, data_ptr
mov rsi, [siguiente_ptr+listElem_off_data]
call funcioncmp ;if(data <= siguiente)  agregar entre (actual,siguiente)
cmp eax, 0
jge .agregar


;sigamos iterando caso contrario
mov actual_ptr, siguiente_ptr
mov siguiente_ptr, [siguiente_ptr+listElem_off_next]
jmp .ciclo

.esVacia:   ;agregue esta etiqueta simplemente por ser didactico
.agregarPrimero:
mov rdi, rbx  ; rbx <- l*
mov rsi, data_ptr 
call listAddFirst
jmp .fin

.agregarUltimo:
mov rdi, rbx  ; rbx <- l*
mov rsi, data_ptr 
call listAddLast
jmp .fin

.agregar:
mov rdi, 24
call malloc   ;tengo en rax la direccion del nuevo nodo
mov [rax+listElem_off_data], data_ptr
mov [actual_ptr+listElem_off_next], rax
mov [siguiente_ptr+listElem_off_prev], rax
mov [rax+listElem_off_prev], actual_ptr
mov [rax+listElem_off_next], siguiente_ptr
jmp .fin

.fin:
;fin stack
add rsp, 8
pop r15
pop r14
pop r13
pop r12
pop rbx
pop rbp
ret




;list_t* listClone(list_t* l, funcDup_t* fn)
; rdi <- list     rsi <- fn
listClone:
	push rbp
	mov rbp, rsp
	push rbx
	push r12
	push r13
	push r14
	%define actual r13
	%define ptrLista rbx
	%define fnDel r12
	mov rbx, rdi 	; rbx=list
	mov r12, rsi 	; r12=fn
	mov rdi, 16
	call listNew
	; r14 apunta a la nueva lista
	mov r14, rax    ; r14=newList
	mov actual, [ptrLista+list_off_last]

.ciclo:
	cmp actual, 0 		; apunto a un nodo?
    je .fin
    ; si actual apunta a un nodo
    ;debo conseguir la data del nodo
 	mov qword rdi, [actual+listElem_off_data]
 	call r12
  	mov rsi, rax
  	mov rdi, r14
 	call listAddFirst
 	mov actual, [actual+listElem_off_prev]
  	jmp .ciclo

.fin:
    mov rax, r14
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rbp
	ret


listDelete:
;rdi <- lista
;rsi <- funDelete

push rbp
mov rbp, rsp
push rbx
push r12

mov rbx, rdi	; rbx=lista
mov r12, rsi	; r12= fDel

.ciclo:
cmp qword [rbx+list_off_first], 0
je .fin

mov qword rdi, rbx
mov rsi, r12
call listRemoveFirst

jmp .ciclo

.fin:
mov rdi, rbx
call free

pop r12
pop rbx
pop rbp
ret





listPrint:
;void listPrint(list_t* l, FILE *pFile, funcPrint_t* fp),             rdi<-l*  rsi<-pFile* rdx<-funcPrint_t*
;funcion del parametro: void (funcPrint_t)(void*, FILE *pFile);

;inicio stack
push rbp
mov rbp, rsp
push rbx
push r12
push r13
push r14  ;actual
push r15  ;siguiente
sub rsp, 8 ;alineado

;cambio registros a los registros que se preservan
mov rbx, rdi   ;rbx <- l*
mov r12, rsi   ;r12 <- pFile*
mov r13, rdx   ;r13 <- funcPrint_t*

;actualizo los definiciones
%define list_ptr          rbx
%define pFile_ptr         r12
%define funcPrint_t_ptr   r13
%define actual_ptr        r14
%define siguiente_ptr     r15

;codigo principal



;printear [
mov rdi, pFile_ptr
mov rsi, formato_printf_string
mov rdx, ch_abrir1
call fprintf
;si es lista vacia no imprimo nada y voy directo a imprimir ]
cmp qword [list_ptr+list_off_first], 0
je .fin

;inicializo actual y siguiente
mov actual_ptr, [list_ptr+list_off_first]
mov siguiente_ptr, [actual_ptr+listElem_off_next]

.ciclo:
cmp funcPrint_t_ptr, 0
je .printPtr
;si no es cero la funcion usarla
mov rdi, [actual_ptr+listElem_off_data]
mov rsi, pFile_ptr 
call funcPrint_t_ptr ;void (funcPrint_t)(void*, FILE *pFile)
jmp .siguiente

.printPtr:  ; quiero hacer fprintf(&pFile ,"%p", &data)
mov rdi, pFile_ptr
mov rsi, formato_printf_ptr
mov rdx, [actual_ptr+listElem_off_data]
call fprintf

.siguiente:
cmp siguiente_ptr, 0
je .fin
mov actual_ptr, siguiente_ptr
mov siguiente_ptr, [siguiente_ptr+listElem_off_next]
;printear `,`
mov rdi, pFile_ptr
mov rsi, formato_printf_string
mov rdx, ch_coma
call fprintf 

jmp .ciclo


.fin:
;printear `]`
mov rdi, pFile_ptr
mov rsi, formato_printf_string
mov rdx, ch_cerrar1
call fprintf 


;fin stack
add rsp, 8
pop r15
pop r14
pop r13
pop r12
pop rbx
pop rbp
ret

;*** Sorter ***
;typedef struct s_sorter{
;	uint16_t size;
;	funcSorter_t *sorterFunction;
;	funcCmp_t *compareFunction;
;	list_t **slots;
;} sorter_t;

%define sorter_off_size 0
%define sorter_off_sorterFunction 8
%define sorter_off_compareFunction 16
%define sorter_off_slots 24

%define sorter_size 32 ;tamaño de la estructura sorter


;sorter_t* sorterNew(uint16_t slots, funcSorter_t* fs, funcCmp_t* fc)
; rdi <- slots   rsi <- funcSorter  rdx<- funCmp
sorterNew:
push rbp
mov rbp, rsp
push rbx
push r12
push r13
push r14

mov rbx, rdi
mov r12, rsi
mov r13, rdx


mov rdi, sorter_size

call malloc
mov r14, rax
; r14 apunta al sorter

mov [r14+sorter_off_size], rbx
mov [r14+sorter_off_sorterFunction], r12
mov [r14+sorter_off_compareFunction], r13


mov rdi, rbx
imul rdi, 8
call malloc

mov [r14+sorter_off_slots], rax

mov r12, 0
.ciclo:
cmp r12, rbx
je .fin

call listNew
mov rcx, [r14+sorter_off_slots]
mov [rcx+r12*8], rax
inc r12
jmp .ciclo

.fin:
mov rax, r14
pop r14
pop r13
pop r12
pop rbx
pop rbp
ret



;void sorterAdd(sorter_t* sorter, void* data)
; rdi<- sorter rsi <- ptrData
sorterAdd:
push rbp
mov rbp, rsp
push rbx
push r12
%define sorter rbx
%define data r12
mov sorter, rdi
mov data, rsi

mov rdi, data
call [sorter+sorter_off_sorterFunction] ;devuelve un int16 bits 64-16=48
movsx rax, ax

; en rax tengo el slot en el que tengo que insertar
; llamamos a listAdd con rdi<- list rsi<- data rdx<- funCMp
mov rdi, [sorter+sorter_off_slots]
mov rdi, [rdi+rax*8]

mov rsi, data
mov rdx, [sorter+sorter_off_compareFunction]

call listAdd

pop r12
pop rbx
pop rbp
ret

;void sorterRemove(sorter_t* sorter, void* data, funcDelete_t* fd)
; rdi <- sorter , rsi <- data rdx<-funcDelete
sorterRemove:
push rbp
mov rbp, rsp
push rbx
push r12
push r13
sub rsp, 8

%define sorter rbx
%define data r12
%define funcDelete r13
mov sorter, rdi
mov data, rsi
mov funcDelete, rdx


mov rdi, data
call [sorter+sorter_off_sorterFunction]
mov rdi, [sorter+sorter_off_slots]
mov rdi, [rdi+rax*8]
; rdi apunta a la lista

mov rsi, data
mov rdx, [sorter+sorter_off_compareFunction]
mov rcx, funcDelete

call listRemove
add rsp, 8
pop r13
pop r12
pop rbx
pop rbp
ret

;list_t* sorterGetSlot(sorter_t* sorter, uint16_t slot, funcDup_t* fn)
; rdi <- sorter , si <- slot   rdx<-funcDup
sorterGetSlot:
push rbp
mov rbp, rsp
movsx rsi, si
mov rcx, [rdi+sorter_off_slots]
mov rcx, [rcx+rsi*8]
mov rdi, rcx
mov rsi, rdx
call listClone
pop rbp
ret




sorterGetConcatSlot: ;char* sorterGetConcatSlot(sorter_t* sorter, uint16_t slot)
;rdi<- sorter si<- slot

;inicio stackframe
push rbp
mov rbp, rsp
push rbx
push r13
push r14
sub rsp, 8

;uso registros preservados
mov rbx, rdi ;rbx<-&sorter

;mov r13  <- siguiente
;mov r14  <- palabraconcatenada


;define
%define actual    rbx
%define siguiente r13
  

;codigo principal
movsx rsi, si


 mov rbx, [rbx+sorter_off_slots]
 mov rbx, [rbx+8*rsi]  ;rbx<-l_i con i=slot

cmp qword [rbx+list_off_first], 0
je .esvacia                          ;si lista es vacia que hacer?
;si hay elementos
mov rbx, [rbx+list_off_first]    ;rbx<- actual
mov r13, [rbx+listElem_off_next] ;r13<-siguiente


;hago primer iteracion fuera del ciclo
mov rdi, [actual+listElem_off_data]
call strClone ;char* strClone(char* a);
mov r14, rax ;en r14 voy guardando el resultado

.ciclo:
cmp siguiente, 0
je .fin

mov actual, siguiente
mov siguiente, [siguiente+listElem_off_next]

mov rdi, [actual+listElem_off_data]
call strClone ;char* strClone(char* a);   esta funcion usa un malloc
mov rdi, r14  ;rdi<- concatenacion acumulada
mov rsi, rax  ;rsi<- actual->data
call strConcat ;char* strConcat(char* a, char* b)  esta funcion usa free en a y b y un maloc para el return
mov r14, rax


jmp .ciclo

.esvacia: ;????
mov rdi, 1
call malloc 
mov byte [rax], 0
;mov rax, 0

.fin:
;fin stackframe
add rsp, 8
pop r14
pop r13
pop rbx
pop rbp
ret



; void sorterCleanSlot(sorter_t* sorter, uint16_t slot, funcDelete_t* fd)
; rdi <- sorter , si <- slot  rdx <- funcDelete
sorterCleanSlot:
push rbp
mov rbp, rsp
push rbx
push r12

%define sorter rbx
%define funcDelete rdx
%define slot r12
movsx rsi, si
mov slot, rsi
mov sorter, rdi

mov rcx, [sorter+sorter_off_slots]
mov rcx, [rcx+rsi*8]

mov rdi, rcx
mov rsi, funcDelete

call listDelete
call listNew

mov rcx, [sorter+sorter_off_slots]
mov [rcx+slot*8], rax

pop r12
pop rbx
pop rbp
ret










;void sorterDelete(sorter_t* sorter, funcDelete_t* fd)
; rdi<- sorter rsi<- funcDelete
sorterDelete:
push rbp
mov rbp, rsp
push rbx
push r12
push r13
sub rsp, 8
%define sorter rbx
%define funcDelete r12
%define i r13

mov sorter, rdi
mov funcDelete, rsi
mov i, 0

.ciclo:
cmp i, [sorter+sorter_off_size]
je .fin

mov rdi, [sorter+sorter_off_slots]
mov rdi, [rdi+i*8]
mov rsi, funcDelete
call listDelete


inc i
jmp .ciclo


.fin:

mov rdi, [sorter+sorter_off_slots]
;mov rdi, [rdi]
call free

mov rdi, sorter
call free


add rsp, 8
pop r13
pop r12
pop rbx
pop rbp
ret







sorterPrint:
;void sorterPrint(sorter_t* sorter, FILE *pFile, funcPrint_t* fp)
 ;rdi<-&sorter rsi<-&pFile  rdx<-&fp

;inicio stackframe
push rbp
mov rbp, rsp
push rbx
push r12
push r13
push r14  ;alineado
push r15
sub rsp, 8

;utilizo registros que se preservan
mov rbx, rdi  ;rbx<- &sorter
mov r12, rsi  ;rsi<- &pfile
mov r13, rdx  ;r13<- &fp
;mov r14       ;cantidad de listas total
;mov r15       ;lista actual para imprimir


;define
%define sorter_ptr    rbx 
%define file_ptr      r12 
%define funcPrint_ptr r13
%define total_listas  r14
%define actual_listas r15
%define x32total_listas  r14d
%define x32actual_listas r15d

;codigo principal

;ciclo llamamos a listPrint con cada lista en el sorter
;inicializar contador
mov r14w, [sorter+sorter_off_size]  ;me ahorra hacer varios accesos a memoria en el ciclo   ; es un int16 si uso reg de 64 debo hacer 64-16=48
shl r14, 48
shr r14, 48 ;<- limpio r14  
mov actual_listas, 0 ;actual empieza en 0 y termina en cantidad de slots-1     
.ciclo:
;por las dudas limpio parte alta de los registros ya que necesito que sean 32 bits para ir iterando y printenado pero 64 para usar lea 
shl r14, 32
shr r14, 32 ;<- limpio r14 
shl r15, 32
shr r15, 32 ;<- limpio r15 

;printeo i =
mov rdi, file_ptr
mov rsi, formato_printf_printsorter
mov edx, x32actual_listas
call fprintf


;elijo la lista para imprimir
mov rdi, [sorter_ptr+sorter_off_slots]
lea rdi, [rdi+8*actual_listas] ;direccion_de_primer_lista + (tamañodepuntero * numerodelista)
mov rdi, [rdi]
;mov rdi <- &lista_i
mov rsi, file_ptr;<- &pfile
mov rdx, funcPrint_ptr ;<- &fp
call listPrint ;void listPrint(list_t* l, FILE *pFile, funcPrint_t* fp)

;printear /n 

mov rdi, file_ptr  
mov rsi, formato_printf_string
mov rdx, sig_linea
call fprintf ;int fprintf(FILE *stream, const char *format, ...)


inc x32actual_listas ;actuallistas+1
cmp x32actual_listas, x32total_listas
je .fin
jmp .ciclo

.fin:
;fin stackframe
add rsp, 8
pop r15
pop r14
pop r13
pop r12
pop rbx
pop rbp
ret



;*** aux Functions ***
;uint16_t fs_sizeModFive(char* s)
; rdi<- s
fs_sizeModFive:
push rbp
call strLen
mov rdx,0
mov ecx, 5
idiv ecx
mov eax, edx
pop rbp
ret

fs_firstChar:
push rbp
mov rax, 0
mov al, [rdi] ;escribir byte aca es ignorado lo borre para que no salga warning ademas 
pop rbp       ;tendria que ser word
ret

fs_bitSplit: ;uint16_t fs_bitSplit(char* s)   
;sil <- &char


push rbp
mov rbp, rsp
mov rax, 0

;codigo principal ;registro de 16 bits
mov sil, [rsi]
;quiero los primeros 8 bits
mov ax, 8
cmp sil, 0
je .fin ;devuelvo un 8 en ax

mov ax, 0
mov dil, 1  ;uso este para comparar

.ciclo:

cmp sil, dil ;comparo "si" con mi numero que es una potencia de 2
je .fin ;guardo la cantidad de veces que entre al ciclo osea ax = la cantidad de potencias que compare
cmp ax, 7
jg .es9  ;si pase por 8,0,1,2,3,4,5,6,7 y ninguno sirvio entonces pongo un 9 directamente
inc ax
shl dil, 1
jmp .ciclo

.es9:
mov ax, 9
.fin:
pop rbp
ret

