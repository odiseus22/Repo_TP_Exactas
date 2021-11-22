global Ocultar_asm



;rdi <-   uint8_t *src,
;rsi <-   uint8_t *src2,
;rdx <-   uint8_t *dst,
;ecx <-   int width,
;r8d <-   int height,
;r9d <-   int src_row_size,
;[rbp+16]  int dst_row_size)

section .rodata
; alinear mascaras
ALIGN 16	
maskExtendC: db 0x00,0x80,0x01,0x80, 0x02,0x80, 0x80,0x80, 0x04,0x80,0x05,0x80, 0x06,0x80, 0x80,0x80
pasarGrisAdword: db 0x00,0x80,0x80,0x80,0x02,0x80,0x80,0x80,0x04,0x80,0x80,0x80,0x06,0x80,0x80,0x80
maskCleansrc1: db 0xfc,0xfc,0xfc,0xff,0xfc,0xfc,0xfc,0xff,0xfc,0xfc,0xfc,0xff,0xfc,0xfc,0xfc,0xff
maskAndGreybit4: db 0x08,0x08,0x08,0x00,0x08,0x08,0x08,0x00,0x08,0x08,0x08,0x00,0x08,0x08,0x08,0x00
maskAndGreybit3: db 0x04,0x04,0x04,0x00,0x04,0x04,0x04,0x00,0x04,0x04,0x04,0x00,0x04,0x04,0x04,0x00
limpiarFinal: db 0x03,0x03,0x03,0x00,0x03,0x03,0x03,0x00,0x03,0x03,0x03,0x00,0x03,0x03,0x03,0x00
invertirPixeles: db 0x0c,0x0d,0x0e,0x0f,0x08,0x09,0x0a,0x0b,0x04,0x05,0x06,0x07,0x00,0x01,0x02,0x03
maskVerdeFinal: db 0x00, 0x00, 0xff,0x00, 0x00,0x00, 0x00,0x00, 0x00,0x00, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00

section .text

Ocultar_asm:
push rbp
push rbx
mov rbp, rsp


%define src1 rdi
%define src2 rsi
%define dst rdx

movdqa xmm15, [maskExtendC]
movdqa xmm14, [pasarGrisAdword]
movdqa xmm13, [maskCleansrc1]
movdqa xmm12, [maskAndGreybit4]
movdqa xmm11, [maskAndGreybit3]
movdqa xmm10, [limpiarFinal]
movdqa xmm9, [maskVerdeFinal]
movdqa xmm8, [invertirPixeles]
; quiero ir levantando de a 4 pixeles de  src 2 y ir pasandolos a grises

mov r10, 0
mov r11, 0
mov r11d, ecx 
imul r11d, r8d
shl r11d, 2


.ciclo:
cmp r10, r11
je .fin
									; xmm0 = |		p3	 |		p2	 |		p1	 |		p0	 |
movdqa xmm0, [src2+r10]				; xmm0 = |a3,r3,g3,b3|a2,r2,g2,b2|a1,r1,g1,b1|a0,r0,g0,b0| 4 dwords

; ahora tengo en xmm1 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

movdqa xmm2, xmm0 					; xmm2 = |a3,r3,g3,b3|a2,r2,g2,b2|a1,r1,g1,b1|a0,r0,g0,b0|

psrldq xmm2, 8						; xmm2 = |	   0		|		0	  |a3,r3,g3,b3|a2,r2,g2,b2|


pshufb xmm2, xmm15 					; xmm2 = |0 0|0 r3|0 g3|0 b3|0 0|0 r2|0 g2|0 b2|
pshufb xmm0, xmm15					; xmm0 = |0 0|0 r1|0 g1|0 b1|0 0|0 r0|0 g0|0 b0|
;;;;;;;;;;;;;;;;;;;;;;;

movdqa xmm3, xmm2 					; xmm3 = |0 0|0 r3|0 g3|0 b3|0 0|0 r2|0 g2|0 b2|
pand xmm3, xmm9		; xmm3 = |0 0|0 0|0 g3|0 0|0 0|0 0|0 g2|0 0|
paddsw xmm2, xmm3 					; xmm2 = |0 0|0 r3|0 2*g3|0 b3|0 0|0 r2|0 2*g2|0 b2|
;;;;;;;;;;;;;;;;;;;;;;;;;;;
movdqa xmm4, xmm0                 
pand xmm4, xmm9

paddsw xmm0, xmm4 					;; xmm2 = |0 0|0 r1|0 2*g1|0 b1|0 0|0 r0|0 2*g0|0 b0|

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
phaddsw xmm0, xmm2                  ; xmm0 = |0 0+r3|0 g3+b3|0 0+r2|0 g2+b2|0 0+r1|0 g1+b1|0 0+r0|0 g0+b0|
movdqa xmm1, xmm0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

phaddsw xmm1, xmm1 					; xmm1 = |b3+g3+r3+0|b2+g2+r2+0|b1+g1+r1+0|b0+g0+r0+0|0 b3+g3+r3+0|0 b2+g2+r2+0|0 b1+g1+r1+0|0 b0+g0+r0+0|

psrlw xmm1, 2 						; divido cada word por 4
									

pshufb xmm1, xmm14					; xmm1 = |0|0|0|p3g|0|0|0|p2g|0|0|0|p1g|0|0|0|p0g|

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ahora traigo los pixeles src1

movdqa xmm2, [src1+r10]				; xmm2 = |a3,r3,g3,b3|a2,r2,g2,b2|a1,r1,g1,b1|a0,r0,g0,b0| 4 dwords

pand xmm2, xmm13 					; xmm2 pero con los 2 menos bits significativos de cada componente rgb en 0

mov rbx, r11
sub rbx, 16
sub rbx, r10

movdqa xmm0, [src1+rbx]				; sup que xmm0 levanta el mirror
pshufb xmm0, xmm8

;xmm0 = |a0,r0,g0,b0|a1,r1,g1,b1|a2,r2,g2,b2|a3,r3,g3,b3| 4 dwords


; xmm0 = |a7,a6,a5,a4,a3,a2,a1,a0|r7,r6,r5,r4,r3,r2,r1,r0|g7,g6,g5,g4,g3,g2,g1,g0|b7,b6,b5,b4,b3,b2,b1,b0|  x4 

; xmm1 = |     0,0,0,0,0,0,0,0   |     0,0,0,0,0,0,0,0   |     0,0,0,0,0,0,0,0   |pg7,pg6,pg5,pg4,pg3,pg2,pg1,pg0| x4

; xmm12= |     0,0,0,0,0,0,0,0   |     0,0,0,0,1,0,0,0   |     0,0,0,0,1,0,0,0   |     0,0,0,0,1,0,0,0   |


pxor xmm3, xmm3

movdqa xmm4, xmm1

pslld xmm4, 17 	; r4
; xmm4= |     0,0,0,0,0,0,0,pg7   |     pg6,pg5,pg4,pg3,*pg2*,pg1,pg0,0   |     0,0,0,0,0,0,0,0   |     0,0,0,0,0,0,0,0   |
pand xmm4, xmm12
por xmm3, xmm4

movdqa xmm4, xmm1

pslld xmm4, 13 ; r3
; xmm4= |     0,0,0,0,0,0,0,0   |     0,0,0,pg7,pg6,*pg5*,pg4,pg3 |    pg2,pg1,pg0,0   |     0,0,0,0,0,0,0,0   |
pand xmm4, xmm11
por xmm3, xmm4

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

movdqa xmm4, xmm1

pslld xmm4, 8 	; g4
; xmm4= |     0,0,0,0,0,0,0,0   |     0,0,0,0,0,0,0,0  |     p7,p6,p5,p4,*p3*,p2,p1,p0   |     0,0,0,0,0,0,0,0   |
pand xmm4, xmm12
por xmm3, xmm4

movdqa xmm4, xmm1

pslld xmm4, 4 ; g3
; xmm4= |     0,0,0,0,0,0,0,0   |     0,0,0,0,0,0,0,0    |       0,0,0,0,p7,*p6*,p5,p4   |     0,0,0,0,1,0,0,0   |
pand xmm4, xmm11
por xmm3, xmm4

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

movdqa xmm4, xmm1

psrld xmm4, 1 ; b4
; xmm4= |     0,0,0,0,0,0,0,0   |     0,0,0,0,0,0,0,0   |     0,0,0,0,0,0,0,0   |0,pg7,pg6,pg5,*pg4*,pg3,pg2,pg1|
pand xmm4, xmm12
por xmm3, xmm4

movdqa xmm4, xmm1

psrld xmm4, 5 ; b3
; xmm4= |     0,0,0,0,0,0,0,0   |     0,0,0,0,0,0,0,0   |     0,0,0,0,0,0,0,0   |0,0,0,0,0,*pg7*,pg6,pg5|
pand xmm4, xmm11
por xmm3, xmm4

; ahora hago xor con el mirror

pxor xmm0, xmm3

psrld xmm0, 2

pand xmm0, xmm10

por xmm2, xmm0

;;;;;;;;;;;;;;;;;;;;;;;;;

movdqa [dst+r10], xmm2 		; aca iba xmm2

add r10, 16 	; 4 pixeles x tamaño de cada pixel
jmp .ciclo


.fin:
pop rbx
pop rbp
ret
