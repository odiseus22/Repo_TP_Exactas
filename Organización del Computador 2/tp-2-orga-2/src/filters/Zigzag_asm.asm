global Zigzag_asm

section .data

section .rodata
mask_1entodo_w: dw 0x0001,0x0001,0x0001,0x0001,0x0001,0x0001,0x0001,0x0001    ;los voy a usar en divicion 128bits=16bytes=16datos
mask_5entodo_w: dw 0x0005,0x0005,0x0005,0x0005,0x0005,0x0005,0x0005,0x0005
mask_255entodo_byte: dw 0xffff,0xffff,0xffff,0xffff,0xffff,0xffff,0xffff,0xffff


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
movdqu [rsi], xmm7  ;pongo 255   leo en |p0|p1|p2|p3|p4|p5|p6|p7|p8| escribo en |p2|p3|p4|p5| 
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

;verificado suma correctamente

;divicion
;cociente devuelvo en: xmm12, xmm13
;xmm15 1 en cada w
;xmm12 5 en cada w
movdqu xmm10, xmm15
movdqu xmm11, xmm10  ;xmm11 1 en cada w
pxor xmm0, xmm0    ;xmm0 =0      
pxor xmm4, xmm4
pxor xmm5, xmm5
mov r10,1275      ;en peor caso tengo 255*5=1275 como sumas
ciclo:           ;65536==2^16 (numero maximo representable)

paddusw xmm0, xmm12 ;sumo 5  a mi reg con i-1 5 sumados
movdqu xmm2, xmm0   
movdqu xmm3, xmm0

pcmpgtw xmm2, xmm8  ;veo si para cada dato ya encontre en i-1 iteraciones al divisor
pcmpgtw xmm3, xmm9

pandn xmm2,xmm10   ;si me pase no necesito sumarle mas a mi cociente,
pandn xmm3,xmm11   ;entonces si me exedo en dato[i] xmm2[i]=1, uso NOT(XMM2) AND variable aumenta cociente,
                   ;de esta forma dejo un cero para no aumentar mas en el cociente,
                   ;del word que ya encontre su cociente

movdqu xmm10, xmm2   ;esto es necesario por el not
movdqu xmm11, xmm3   ;en xmm10 y xmm11 obtengo 0 en cada word que ya consegui divisor

paddusw xmm4,xmm10 ;en xmm4 y xmm5 obtengo cociente    ;debug aca
paddusw xmm5,xmm11

;veamos si encontre cocientes, entonces salir
movdqu xmm14, xmm10   ;uso xmm14 para ver si ya puedo salir del ciclo, 
packuswb xmm14, xmm11 ;no puedo usar xmm12 si sigo en ciclo 
;en xmm14 obtengo de las 16 divisiones cual aun no termino con un 1

pextrq r11, xmm14 , 00000000b  
cmp r11,0
jne seguir
pextrq r11, xmm14, 00000001b
cmp r11, 0
je tenemoscociente

seguir:
dec r10
cmp r10, 0
je tenemoscociente
jmp ciclo 
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



bajarfila:
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
