global Zigzag_asm

section .data

section .rodata
mask_1entodo_w: dw 0x0001,0x0001,0x0001,0x0001,0x0001,0x0001,0x0001,0x0001    ;los voy a usar en divicion 128bits=16bytes=16datos 
;PARA DIVIDIR CON FLOATS
mask_5entodo_w: times 4 dd 5.0         ; mask_5entodo_w: times 8 dw 0x0005   
mask_255entodo_byte: dw 0xffff,0xffff,0xffff,0xffff,0xffff,0xffff,0xffff,0xffff     ;mask_5entodo_w: times 8 dd 5.0      (32bits)  con dq es(64 bits)

section .text
Zigzag_asm:
;void Zigzag_asm (uint8_t *src, uint8_t *dst, int width, int height,int src_row_size, int dst_row_size);
;rdi <-*src   rsi<-*dst   edx<-width   ecx<-height   r8d<-rc_row_size   r9d<-dst_row_size


;cada componente de un pixel ocupa 1 byte, cada pixel tiene 4 componentes, cada pixel ocupa 4 byte=32bits
;xmm tiene 128 bits =16 byte   en cada xmm entran 4 pixeles


;inicio stackframe
push rbp
mov rbp,rsp
push r12
push r13


;defines utiles
%define shift_pixel  4 ;cuantos bytes salto para desplazarme un pixel

;cargar mascaras
movdqu xmm15, [mask_1entodo_w]
movdqu xmm12, [mask_5entodo_w]
movdqu xmm7, [mask_255entodo_byte]
;CODIGO PRINCIPAL



;rax  rdx libres
; src posicion inicial      memoria = tamañodato(tamañofila*Nfila+Ncolummna)
;rdi <-*src   rsi<-*dst   edx<-width   ecx<-height   r8d<-rc_row_size   r9d<-dst_row_size
;ancho mayor a 16 pixeles y multiplo de 8 pixeles
mov r8d,0 ;<-0  ;fila
mov r9d,0 ;<-0 ;columna
mov r12d, edx ;porque usare div
cicloenmatriz:

cmp r8d, 2
jl agregar255filas
mov eax, ecx
sub eax, 2
cmp r8d, eax  ;ecx-2
jge agregar255filas
jmp cicloenfilas


agregar255filas:
movdqu [rsi], xmm7         ;posicionamos 4 pixeles  pixel=4bytes 4*4 =16 bytes
movdqu [rsi+16], xmm7      ;posicionamos 4 mas
add rsi, 32
add rdi, 32  ;alineados a 32bytes=8 pixeles (sabemos que la matriz tiene ancho=8*k)
add r9d, 8
cmp r9d, r12d
je bajarfila
jmp agregar255filas

cicloenfilas:
movdqu [rsi], xmm7  ;pongo 255   leo en |p0|p1|p2|p3|p4|p5|p6|p7|p8| escribo en |p2|p3|p4|p5|                                ;si uso movq pisa solo lo que necesito???
add rsi, 8 ;desplazo 2 pixeles para que tenga correcto alineamiento las funciones zigzager metershr2 y metershl2
;add r9d, 2 ;indico que avance 2 pixeles  NO LO HAGO, R9D INDICA EN DONDE LEO

mov eax, r8d
xor edx, edx
mov r10d, 4
div r10d ; divido r8d con 4      divisor EAX resto EDX 
cmp edx,0
je zigzager
cmp edx,1
je metershrx2
cmp edx,2
je zigzager
cmp edx,3
je metershlx2





;/////////////////////////////////////////////////////// FUNCIONES CICLANTES POR FILA \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

metershrx2:      ;estamos escribiendo en posicion|p2|p3|p4|p5|p6|p7|p8|p9| y ponemos  |p0|p1|p2|p3|p4|p5|p6|p7|         
movdqu xmm0, [rdi]   ;xmm0 <- |p0|p1|p2|p3|
movdqu xmm1, [rdi+16] ;xmm0 <- |p4|p5|p6|p7|
movdqu [rsi], xmm0
movdqu [rsi+16], xmm1
add rsi,32
add rdi,32

add r9d, 8 ;este numero indica la columna de la matriz original (la de lectura)
mov eax, r12d
sub eax, 8
cmp r9d, eax    ;comparo columna con ancho-8 =r12d-8
jge ajustarfinalshrx2
jmp metershrx2

ajustarfinalshrx2: ;estamos escribiendo en posicion|p2|p3|p4|p5|p6|p7|p8|p9| y ponemos  |p0|p1|p2|p3|p4|p5|p6|p7|  
                                                              ;|255x2|ERROR|
movdqu xmm0, [rdi]   ;xmm0 <- |p0|p1|p2|p3|                          ;estoy escribiendo el la linea que sigue
;movdqu xmm1, [rdi+16] ;xmm0 <- |p4|p5|p6|p7|
movdqu [rsi], xmm0
movdqu [rsi+16], xmm7 ;pongo 255
add rsi, 24 ;32-8=24  8 son 2 pixeles para que rsi estee alineado al principio de la fila  
add rdi, 32           
jmp bajarfila




metershlx2: ;estamos escribiendo en posicion |p2|p3|p4|p5|p6|p7|p8|p9|  y ponemos |p4|p5|p6|p7|p8|p9|p10|p11|
                                               ;(desplazado x el marco)
add rdi, 16 ;nos salteamos 2 para poner los 2 vecinos de la derecha y otros 2 para el shift (saltamos 4 pixeles)
add r9d, 4
shiftleftx2ciclo:
movdqu xmm0, [rdi]   ;xmm0 <- |p0|p1|p2|p3|
movdqu xmm1, [rdi+16] ;xmm0 <- |p4|p5|p6|p7|
movdqu [rsi], xmm0
movdqu [rsi+16], xmm1
add rsi,32
add rdi,32

add r9d, 8 ;este numero indica la columna de la matriz que estoy leyendo
mov eax, r12d
sub eax, 8
cmp r9d, eax;wdith-8
jge ajustarfinalshlx2
jmp shiftleftx2ciclo

ajustarfinalshlx2: ;estamos escribiendo en posicion|p2|p3|p4|p5|p6|p7|p8|p9| y ponemos  |p4|p5|p6|p7|p8|p9|p5|p6|
                                                              ;|255x2|ERROR|                        |err|err|err|err|
movdqu xmm0, [rdi]   ;xmm0 <- |p0|p1|p2|p3|                          ;estoy escribiendo el la linea que sigue                                
;movdqu xmm1, [rdi+16] ;xmm0 <- |p4|p5|p6|p7|
movdqu [rsi], xmm0
movdqu [rsi+16], xmm7 ;pongo 255
add rsi, 24 ;32-8=24  8 son 2 pixeles para que rsi estee alineado al principio de la fila            ;donde escribimos
add rdi, 16 ;32-16=16 16 son 4 pixeles para que rdi estee alineado al principio de la fila           ;donde leeemos 
jmp bajarfila
    
zigzager:

movdqu xmm0, [rdi]          ;xmm0<-|p0|p1|p2|p3| *
movdqu xmm1, [rdi+16]       ;xmm1<-|p4|p5|p6|p7| *

;SUMAMOS SHIFT_L Y SHIFT_LX2  A LOS DATOS ORIGINALES                           
movdqu xmm2, xmm0           ;xmm2<-|p0|p1|p2|p3|
movdqu xmm3, xmm1           ;xmm3<-|p4|p5|p6|p7|
;nos armamos los parametros para sumar al registro alto xmm1
pslldq xmm3, shift_pixel    ;xmm3<-|00|p4|p5|p6|
movdqu xmm5, xmm3         
pslldq xmm5, shift_pixel    ;xmm5<-|00|00|p4|p5|

movdqu xmm6, xmm0           ;xmm6<-|p0|p1|p2|p3|
psrldq xmm6, shift_pixel*2  ;xmm6<-|p2|p3|00|00|
paddusb xmm5, xmm6          ;xmm5<-|p2|p3|p4|p5| *

psrldq xmm6, shift_pixel    ;xmm6<-|p3|00|00|00|
paddusb xmm3, xmm6          ;xmm3<-|p3|p4|p5|p6| *

;nos armamos los parametros para sumar al registro bajo xmm0
pslldq xmm2, shift_pixel  ;xmm2<-|00|p0|p1|p2| *
movdqu xmm4, xmm2
pslldq xmm4, shift_pixel  ;xmm4<-|00|00|p0|p1| *

;ponemos en los bits  mas significativo en las posiciones menos significativas,expandimos, sumamos  en el registro bajo 
movdqu xmm6, xmm0           ;xmm6<-|p0|p1|p2|p3|
psrldq xmm6, shift_pixel*2  ;xmm6<-|p2|p3|00|00|
pmovzxbw xmm8, xmm6         ;xmm8<-| p2 | p3 | 

movdqu xmm6, xmm2           ;xmm6<-|00|p0|p1|p2|
psrldq xmm6, shift_pixel*2  ;xmm6<-|p1|p2||00|00|
pmovzxbw xmm6, xmm6         ;xmm6<-| p1 | p2 |

paddusw xmm8, xmm6         ;xmm8 | p2+p1 | p3+p2 |


movdqu xmm6, xmm4           ;xmm6<-|00|00|p0|p1| 
psrldq xmm6, shift_pixel*2  ;xmm6<-|p0|p1||00|00|
pmovzxbw xmm6, xmm6         ;xmm6<-| p0 | p1 |

paddusw xmm8, xmm6         ;xmm8 | p2+p1+p0 | p3+p2+p1 |**

;ponemos en los bits menos significativo,expandimos, sumamos  en el registro alto 

pmovzxbw xmm9, xmm1        ;xmm9<-| p4 | p5 |
pmovzxbw xmm6, xmm3        ;xmm6<-| p3 | p4 |
paddusw xmm9, xmm6         ;xmm9<-| p4+p3 | p5+p4 |
pmovzxbw xmm6, xmm5        ;xmm6<-| p2 | p3 |
paddusw xmm9, xmm6         ;xmm9<-| p4+p3+p2 | p5+p4+p3 |**


;SUMAMOS SHIFT_R Y SHIFT_RX2  A LOS DATOS ORIGINALES   
movdqu xmm2, xmm0           ;xmm2<-|p0|p1|p2|p3|
movdqu xmm3, xmm1           ;xmm3<-|p4|p5|p6|p7|

;nos armamos los parametros para sumar al registro bajo xmm0
psrldq xmm2, shift_pixel    ;xmm2<-|p1|p2|p3|00|
movdqu xmm4, xmm2
psrldq xmm4, shift_pixel   ;xmm4<-|p2|p3|00|00|

movdqu xmm6, xmm1           ;xmm6<-|p4|p5|p6|p7|
pslldq xmm6, shift_pixel*2  ;xmm6  |00|00|p4|p5|
paddusw xmm4, xmm6          ;xmm4<-|p2|p3|p4|p5|*
pslldq xmm6, shift_pixel    ;xmm6  |00|00|00|p4|
paddusw xmm2, xmm6          ;xmm2<-|p1|p2|p3|p4|*

;nos armamos los parametros para sumar al registro alto xmm1
psrldq xmm3, shift_pixel    ;xmm3<-|p5|p6|p7|00|*
movdqu xmm5, xmm3
psrldq xmm5, shift_pixel    ;xmm5<-|p6|p7|00|00|*

;ponemos en los bits  mas significativo en las posiciones menos significativas,expandimos, sumamos  en el registro bajo 
movdqu xmm6, xmm2           ;xmm6<-|p1|p2|p3|p4|
psrldq xmm6, shift_pixel*2  ;xmm6<-|p3|p4||00|00|
pmovzxbw xmm6, xmm6         ;xmm6<-| p3 | p4 |

paddusw xmm8, xmm6         ;xmm8 | p2+p1+p0+p3 | p3+p2+p1+p4 |**


movdqu xmm6, xmm4           ;xmm4<-|p2|p3|p4|p5|
psrldq xmm6, shift_pixel*2  ;xmm6<-|p4|p5||00|00|
pmovzxbw xmm6, xmm6         ;xmm6<-| p4 | p5 |

paddusw xmm8, xmm6         ;xmm8 | p2+p1+p0+p3+p4 | p3+p2+p1+p4+p5 |**

;ponemos en los bits menos significativo,expandimos, sumamos  en el registro alto 
pmovzxbw xmm6, xmm3        ;xmm3<-|p5|p6|p7|00|*
paddusw xmm9, xmm6         ;xmm9<-| p4+p3+p2+p5 | p5+p4+p3+p6 |**
pmovzxbw xmm6, xmm5        ;xmm6<-| p6 | p7 |
paddusw xmm9, xmm6         ;xmm9<-| p4+p3+p2+p5+p6 | p5+p4+p3+p6+p7 |**

;el resultado esta en xmm8 y xmm9 respectivamente | p2+p1+p0+p3+p4 | p3+p2+p1+p4+p5 | y | p4+p3+p2+p5+p6 | p5+p4+p3+p6+p7 |
                                                 ;|       s2       |       s3       |   |       s4       |       s5       |
                                 ;son 2 pixeles por registro, cada pixel 4 elementos, 8 words  son 16 sumas agrupadas en 4 grupos(4pixeles) de 4 componentes
;verificado suma correctamente

;despempaquetamos las sumas a 32 bits
;divicion con floats                        ;en xmm12 tengo la mascara divisiora de 5

movdqu xmm0,xmm8
movdqu xmm1,xmm9 
psrldq xmm8, 8       ;parte alta es xmm8 y xmm9 parte baja es xmm0 y xmm1   , xmm0 y xmm8 tienen suma s2 y s3, mientras que
psrldq xmm9, 8       ;xmm1 y xmm9 tienen suma s4 y s5, por lo tanto se deben juntar estos 2: xmm0 y xmm8  y estos 2: xmm1 y xmm9 
pmovzxwd xmm8, xmm8
pmovzxwd xmm9, xmm9
pmovzxwd xmm0, xmm0
pmovzxwd xmm1, xmm1

cvtdq2ps xmm0, xmm0
cvtdq2ps xmm1, xmm1
cvtdq2ps xmm8, xmm8
cvtdq2ps xmm9, xmm9 

divps xmm0, xmm12
divps xmm1, xmm12 
divps xmm8, xmm12
divps xmm9, xmm12

cvtps2dq xmm0, xmm0
cvtps2dq xmm1, xmm1
cvtps2dq xmm8, xmm8
cvtps2dq xmm9, xmm9  ;estan los datos en 32 bits los queremos en

packusdw xmm0, xmm8
packusdw xmm1, xmm9

movdqu xmm4, xmm0
movdqu xmm5, xmm1 


je tenemoscociente

                                        ;xmm4                                     xmm5                    recordar que tenemos los datos en 4words por cada pixel
tenemoscociente:     ;|       s2/5       |       s3/5       |   |       s4/5       |       s5/5       |
  
packuswb xmm4, xmm5 ;|s2/5|s3/5|s4/5|s5/5|
movdqu [rsi], xmm4
;pextrq r10, xmm4 , 00000000b  ;almaceno la parte menos significativa
;mov [rsi],r10   ;almacenamos 8 bytes  64/8=8
;pextrq r10, xmm4 , 00000001b   ;almaceno la parte mas significativa
;mov [rsi+8], r10
add rsi,16  ; escribo 4 pixeles 4*4 (4 bytes x pixel)=16  
add rdi,16  ;leo 8 pero solo avanzo 4

add r9d, 4  ;indica posicion en columna (en pixeles) de la matriz de lectura
mov eax, r12d
sub eax, 4
cmp r9d, eax ;width-4     es eL caso que leo de la matriz :   |p|p|p|p|err|err|err|err|  (leo 4 pixeles de la fila que suige)
                                            ;escribo en           |p|p|err|err|
jge ajustarfinalzigzager
jmp zigzager

ajustarfinalzigzager: ;estamos escribiendo en posicion|p2|p3|p4|p5|                              y leemos |p0|p1|p2|p3|p4|p5|p6|p7|    
                                                      ;|           |255|255|ERROR|ERROR|
movdqu [rsi], xmm7                                                         ;AQUI ESCRIBIMOS EN  PROXIMA FILA
add rdi, 16; estabamos 4 pixeles antes de terminar la fila, necesitamos alinear al principio de la fila el lector  
add rsi, 8;  Avanzo  solo medio  registro para poner quedar alineado al comienzo de la proxima fila, escribo 4 pixeles, 
;pero los 2 primeros son el fin de la fila y los otros 2 el comienzo de la otra

jmp bajarfila

;/////////////////////////////////////////////////////// FUNCIONES CICLANTES POR FILA \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\



bajarfila: ;no actualiza punteros
inc r8d
xor r9d, r9d
cmp r8d, ecx
je finciclomatriz
jmp cicloenmatriz

finciclomatriz:

;fin stackframe
pop r13
pop r12
pop rbp
ret
