rm(list=ls()) 

dataAsm_enteros <-read.table('dataASM_enteros.csv',sep= ',',header = TRUE)
dataAsm_float <-read.table('dataASM_float.csv',sep= ',',header = TRUE)
dataC0 <-read.table('dataC0.csv',sep= ',',header = TRUE)  #c0=sin optimizacion
dataC3 <-read.table('dataC3.csv',sep= ',',header = TRUE)  #c3=con optimizacion

#conseguimos los distintos tamaños
#tamanosaux <-dataexp$size
#tamanosaux <- unique(tamanosaux)


#HARDCODEAMOS LOS TAMANOS
tamanos =c("32x16","64x32","128x64","200x100","256x128","400x200","512x256" ,"800x400","1600x800")

#armemos valores para el grafico   

#ASM
i <-0
tiemposClockAsm_enteros<- rep(0.0,9)
tiemposMsAsm_enteros <- rep(0.0,9)
errorMsAsm_enteros <- rep(0.0,9)
while (i<=9){
  tiemposClockAsm_enteros[i]<-mean(dataAsm_enteros$clocks[ dataAsm_enteros$size == tamanos[i] ])
  tiemposMsAsm_enteros[i]<-mean(dataAsm_enteros$ms[ dataAsm_enteros$size == tamanos[i] ])
  errorMsAsm_enteros[i]<-sd(dataAsm_enteros$ms[ dataAsm_enteros$size == tamanos[i] ])
  i=i+1;
}

i <-0
tiemposClockAsm_float <- rep(0.0,9)
tiemposMsAsm_float<- rep(0.0,9)
errorMsAsm_float <- rep(0.0,9)
while (i<=9){
  tiemposClockAsm_float[i]<-mean(dataAsm_float$clocks[ dataAsm_float$size == tamanos[i] ])
  tiemposMsAsm_float[i]<-mean(dataAsm_float$ms[ dataAsm_float$size == tamanos[i] ])
  errorMsAsm_float[i]<-sd(dataAsm_float$ms[ dataAsm_float$size == tamanos[i] ])
  i=i+1;
}


#C0
i <-0
tiemposClockC0 <- rep(0.0,9)
tiemposMsC0 <- rep(0.0,9)
errorMsC0 <- rep(0.0,9)
while (i<=9){
  tiemposClockC0[i]<-mean(dataC0$clocks[ dataC0$size == tamanos[i] ])
  tiemposMsC0[i]<-mean(dataC0$ms[ dataC0$size == tamanos[i] ])
  errorMsC0[i]<-sd(dataC0$ms[ dataC0$size == tamanos[i] ])
  i=i+1;
}


#C3
i <-0
tiemposClockC3 <- rep(0.0,9)
tiemposMsC3 <- rep(0.0,9)
errorMsC3 <- rep(0.0,9)
while (i<=9){
  tiemposClockC3[i]<-mean(dataC3$clocks[ dataC3$size == tamanos[i] ])
  tiemposMsC3[i]<-mean(dataC3$ms[ dataC3$size == tamanos[i] ])
  errorMsC3[i]<-sd(dataC3$ms[ dataC0$size == tamanos[i] ])
  i=i+1;
}



RAsm_enteros<-range(tiemposMsAsm_enteros)
RAsm_float<-range(tiemposMsAsm_float)
RC0<-range(tiemposMsC0)
RC3<-range(tiemposMsC3)

MaxAsm_enteros<-round(RAsm_enteros[2])
MaxAsm_float<-round(RAsm_float[2])
MaxC0 <-round(RC0[2])
MaxC3 <-round(RC3[2])
  
intervalos<- c(RAsm_float,RAsm_enteros,RC0,RC3)
intervalos1<- c(RAsm_float,RC0,RC3)

MAXIMO <- as.integer(max(intervalos))+1
MAXIMO1 <- as.integer(max(intervalos1))+1
x<-c(1,2,3,4,5,6,7,8,9)



#C VS ASSEMBLER


#tiemosMs    enrrealidad es tiempo de clock x1000
#plot(x=c(1,2,3,4,5,6,7,8,9),y=tiemposMsAsm_enteros,xlab = "tamaño", ylab = "tiempo MS",xlim=c(1,9),   ylim=c(0, MAXIMO ),main="ASM vs C0 vs C3", xaxt="n")
#lines(x=c(1,2,3,4,5,6,7,8,9),y=tiemposMsAsm_enteros,xlab = "tama?o", ylab = "tiempo MS",xlim=c(1,9), col="blue")

plot(x=c(1,2,3,4,5,6,7,8,9),y=tiemposMsAsm_float,xlab = "tamaño", ylab = "tiempo MS",xlim=c(1,9),   ylim=c(0, MAXIMO1 ),main="ASM vs C0 vs C3", xaxt="n")
lines(x=c(1,2,3,4,5,6,7,8,9),y=tiemposMsAsm_float,xlab = "tama?o", ylab = "tiempo MS",xlim=c(1,9), col="orange")

points(x=c(1,2,3,4,5,6,7,8,9),y=tiemposMsC0,xlab = "tamaño", ylab = "tiempo MS",xlim=c(1,9),ylim=c(0, MAXIMO ))
lines(x=c(1,2,3,4,5,6,7,8,9),y=tiemposMsC0,xlab = "tamaño", ylab = "tiempo MS",xlim=c(1,9),ylim=c(0, MAXIMO ),    col="red")

points(x=c(1,2,3,4,5,6,7,8,9),y=tiemposMsC3,xlab = "tamaño", ylab = "tiempo MS",xlim=c(1,9),ylim=c(0, MAXIMO ))
lines(x=c(1,2,3,4,5,6,7,8,9),y=tiemposMsC3,xlab = "tamaño", ylab = "tiempo MS",xlim=c(1,9),ylim=c(0, MAXIMO ), col="green" )
legend("topleft", c("Implementacion","Asm_float","C0","C3","Maximos",MaxAsm_float,MaxC0,MaxC3),fill=c("black","orange","red","green"))
axis(side=1,at=x,labels=tamanos,las=0,cex.axis=0.71)

i<-1
while(i<=9){
  
  #asm_enteros
  #arrows(x0=i,y0=tiemposMsAsm_enteros[i],x1=i,y1=tiemposMsAsm_enteros[i]+errorMsAsm_enteros[i],angle=90, length=0.1, col="blue", lwd=1)
  #arrows(x0=i,y0=tiemposMsAsm_enteros[i],x1=i,y1=tiemposMsAsm_enteros[i]-errorMsAsm_enteros[i],angle=90, length=0.1, col="blue", lwd=1)
  
  #asm_float
  arrows(x0=i,y0=tiemposMsAsm_float[i],x1=i,y1=tiemposMsAsm_float[i]+errorMsAsm_float[i],angle=90, length=0.1, col="orange", lwd=1)
  arrows(x0=i,y0=tiemposMsAsm_float[i],x1=i,y1=tiemposMsAsm_float[i]-errorMsAsm_float[i],angle=90, length=0.1, col="orange", lwd=1)
  
  
  
  #c0
  arrows(x0=i,y0=tiemposMsC0[i],x1=i,y1=tiemposMsC0[i]+errorMsC0[i],angle=90, length=0.1, col="red", lwd=1)
  arrows(x0=i,y0=tiemposMsC0[i],x1=i,y1=tiemposMsC0[i]-errorMsC0[i],angle=90, length=0.1, col="red", lwd=1)
  
  #c3
  arrows(x0=i,y0=tiemposMsC3[i],x1=i,y1=tiemposMsC3[i]+errorMsC3[i],angle=90, length=0.1, col="green", lwd=1)
  arrows(x0=i,y0=tiemposMsC3[i],x1=i,y1=tiemposMsC3[i]-errorMsC3[i],angle=90, length=0.1, col="green", lwd=1)
  
  i=i+1
}

intervalos2<- c(MaxAsm_enteros,MaxAsm_float)
MAXIMO2 <- as.integer(min(intervalos2))+1

#MENOR ESCALA
#plot(x=c(1,2,3,4,5,6,7,8,9),y=tiemposMsAsm_enteros,xlab = "tama?o", ylab = "tiempo MS",xlim=c(1,9),   ylim=c(0, MAXIMO ),main="ASM vs C0 vs C3", xaxt="n")
#lines(x=c(1,2,3,4,5,6,7,8,9),y=tiemposMsAsm_enteros,xlab = "tama?o", ylab = "tiempo MS",xlim=c(1,9), col="blue")

plot(x=c(1,2,3,4,5,6,7,8,9),y=tiemposMsAsm_float,xlab = "tamaño", ylab = "tiempo MS",xlim=c(1,9),   ylim=c(0, MAXIMO2 ),main="ASM vs C0 vs C3", xaxt="n")
lines(x=c(1,2,3,4,5,6,7,8,9),y=tiemposMsAsm_float,xlab = "tama?o", ylab = "tiempo MS",xlim=c(1,9), col="orange")

points(x=c(1,2,3,4,5,6,7,8,9),y=tiemposMsC0,xlab = "tamaño", ylab = "tiempo MS",xlim=c(1,9),ylim=c(0, MAXIMO ))
lines(x=c(1,2,3,4,5,6,7,8,9),y=tiemposMsC0,xlab = "tamaño", ylab = "tiempo MS",xlim=c(1,9),ylim=c(0, MAXIMO ),    col="red")

points(x=c(1,2,3,4,5,6,7,8,9),y=tiemposMsC3,xlab = "tamaño", ylab = "tiempo MS",xlim=c(1,9),ylim=c(0, MAXIMO ))
lines(x=c(1,2,3,4,5,6,7,8,9),y=tiemposMsC3,xlab = "tamaño", ylab = "tiempo MS",xlim=c(1,9),ylim=c(0, MAXIMO ), col="green" )
legend("topleft", c("Implementacion","Asm_enteros","Asm_float","C0","C3","Maximos",MaxAsm_enteros,MaxAsm_float,MaxC0,MaxC3),fill=c("black","blue","orange","red","green"))
axis(side=1,at=x,labels=tamanos,las=0,,cex.axis=0.71)

i<-1
while(i<=9){
  
  #asm_enteros
  #arrows(x0=i,y0=tiemposMsAsm_enteros[i],x1=i,y1=tiemposMsAsm_enteros[i]+errorMsAsm_enteros[i],angle=90, length=0.1, col="blue", lwd=1)
  #arrows(x0=i,y0=tiemposMsAsm_enteros[i],x1=i,y1=tiemposMsAsm_enteros[i]-errorMsAsm_enteros[i],angle=90, length=0.1, col="blue", lwd=1)
  
  #asm_float
  arrows(x0=i,y0=tiemposMsAsm_float[i],x1=i,y1=tiemposMsAsm_float[i]+errorMsAsm_float[i],angle=90, length=0.1, col="orange", lwd=1)
  arrows(x0=i,y0=tiemposMsAsm_float[i],x1=i,y1=tiemposMsAsm_float[i]-errorMsAsm_float[i],angle=90, length=0.1, col="orange", lwd=1)
  
  
  
  #c0
  arrows(x0=i,y0=tiemposMsC0[i],x1=i,y1=tiemposMsC0[i]+errorMsC0[i],angle=90, length=0.1, col="red", lwd=1)
  arrows(x0=i,y0=tiemposMsC0[i],x1=i,y1=tiemposMsC0[i]-errorMsC0[i],angle=90, length=0.1, col="red", lwd=1)
  
  #c3
  arrows(x0=i,y0=tiemposMsC3[i],x1=i,y1=tiemposMsC3[i]+errorMsC3[i],angle=90, length=0.1, col="green", lwd=1)
  arrows(x0=i,y0=tiemposMsC3[i],x1=i,y1=tiemposMsC3[i]-errorMsC3[i],angle=90, length=0.1, col="green", lwd=1)
  
  i=i+1
}


MAXIMO <- as.integer(max(intervalos))+1
#ASM VS ASM_FLOAT

#tiemosMs    enrrealidad es tiempo de clock x1000
plot(x=c(1,2,3,4,5,6,7,8,9),y=tiemposMsAsm_enteros,xlab = "tamano", ylab = "tiempo MS",xlim=c(1,9),   ylim=c(0, MAXIMO ),main="ZIGZAG-ENTEROS-VS-FLOAT", xaxt="n")
lines(x=c(1,2,3,4,5,6,7,8,9),y=tiemposMsAsm_enteros,xlab = "tama?o", ylab = "tiempo MS",xlim=c(1,9), col="blue")

points(x=c(1,2,3,4,5,6,7,8,9),y=tiemposMsAsm_float,xlab = "tama?o", ylab = "tiempo MS",xlim=c(1,9),   ylim=c(0, MAXIMO ),main="ASM vs C0 vs C3")
lines(x=c(1,2,3,4,5,6,7,8,9),y=tiemposMsAsm_float,xlab = "tama?o", ylab = "tiempo MS",xlim=c(1,9), col="orange")

#points(x=c(1,2,3,4,5,6,7,8,9),y=tiemposMsC0,xlab = "tamaño", ylab = "tiempo MS",xlim=c(1,9),ylim=c(0, MAXIMO ))
#lines(x=c(1,2,3,4,5,6,7,8,9),y=tiemposMsC0,xlab = "tamaño", ylab = "tiempo MS",xlim=c(1,9),ylim=c(0, MAXIMO ),    col="red")

#points(x=c(1,2,3,4,5,6,7,8,9),y=tiemposMsC3,xlab = "tamaño", ylab = "tiempo MS",xlim=c(1,9),ylim=c(0, MAXIMO ))
#lines(x=c(1,2,3,4,5,6,7,8,9),y=tiemposMsC3,xlab = "tamaño", ylab = "tiempo MS",xlim=c(1,9),ylim=c(0, MAXIMO ), col="green" )
legend("topleft", c("Implementacion","Asm_enteros","Asm_float","Maximos",MaxAsm_enteros,MaxAsm_float),fill=c("black","blue","orange"))
axis(side=1,at=x,labels=tamanos,las=0,cex.axis=0.71)

i<-1
while(i<=9){
  
  #asm_enteros
  arrows(x0=i,y0=tiemposMsAsm_enteros[i],x1=i,y1=tiemposMsAsm_enteros[i]+errorMsAsm_enteros[i],angle=90, length=0.1, col="blue", lwd=1)
  arrows(x0=i,y0=tiemposMsAsm_enteros[i],x1=i,y1=tiemposMsAsm_enteros[i]-errorMsAsm_enteros[i],angle=90, length=0.1, col="blue", lwd=1)
  
  #asm_float
  arrows(x0=i,y0=tiemposMsAsm_float[i],x1=i,y1=tiemposMsAsm_float[i]+errorMsAsm_float[i],angle=90, length=0.1, col="orange", lwd=1)
  arrows(x0=i,y0=tiemposMsAsm_float[i],x1=i,y1=tiemposMsAsm_float[i]-errorMsAsm_float[i],angle=90, length=0.1, col="orange", lwd=1)
  
  
  
  #c0
  #arrows(x0=i,y0=tiemposMsC0[i],x1=i,y1=tiemposMsC0[i]+errorMsC0[i],angle=90, length=0.1, col="red", lwd=1)
  #arrows(x0=i,y0=tiemposMsC0[i],x1=i,y1=tiemposMsC0[i]-errorMsC0[i],angle=90, length=0.1, col="red", lwd=1)
  
  #c3
  #arrows(x0=i,y0=tiemposMsC3[i],x1=i,y1=tiemposMsC3[i]+errorMsC3[i],angle=90, length=0.1, col="green", lwd=1)
  #arrows(x0=i,y0=tiemposMsC3[i],x1=i,y1=tiemposMsC3[i]-errorMsC3[i],angle=90, length=0.1, col="green", lwd=1)
  
  i=i+1
}

intervalos2<- c(MaxAsm_enteros,MaxAsm_float)
MAXIMO <- as.integer(min(intervalos2))+1

#MENOR ESCALA
plot(x=c(1,2,3,4,5,6,7,8,9),y=tiemposMsAsm_enteros,xlab = "tamaño", ylab = "tiempo MS",xlim=c(1,9),   ylim=c(0, MaxAsm_enteros ),main="ASM_enteros vs ASM_float vs C0 vs C3", xaxt="n")
lines(x=c(1,2,3,4,5,6,7,8,9),y=tiemposMsAsm_enteros,xlab = "tama?o", ylab = "tiempo MS",xlim=c(1,9), col="blue")

points(x=c(1,2,3,4,5,6,7,8,9),y=tiemposMsAsm_float,xlab = "tama?o", ylab = "tiempo MS",xlim=c(1,9),   ylim=c(0, MAXIMO ),main="ASM vs C0 vs C3")
lines(x=c(1,2,3,4,5,6,7,8,9),y=tiemposMsAsm_float,xlab = "tama?o", ylab = "tiempo MS",xlim=c(1,9), col="orange")

points(x=c(1,2,3,4,5,6,7,8,9),y=tiemposMsC0,xlab = "tamaño", ylab = "tiempo MS",xlim=c(1,9),ylim=c(0, MAXIMO ))
lines(x=c(1,2,3,4,5,6,7,8,9),y=tiemposMsC0,xlab = "tamaño", ylab = "tiempo MS",xlim=c(1,9),ylim=c(0, MAXIMO ),    col="red")

points(x=c(1,2,3,4,5,6,7,8,9),y=tiemposMsC3,xlab = "tamaño", ylab = "tiempo MS",xlim=c(1,9),ylim=c(0, MAXIMO ))
lines(x=c(1,2,3,4,5,6,7,8,9),y=tiemposMsC3,xlab = "tamaño", ylab = "tiempo MS",xlim=c(1,9),ylim=c(0, MAXIMO ), col="green" )
legend("topleft", c("Implementacion","Asm_enteros","Asm_float","C0","C3","Maximos",MaxAsm_enteros,MaxAsm_float,MaxC0,MaxC3),fill=c("black","blue","orange","red","green"))
axis(side=1,at=x,labels=tamanos,las=0,,cex.axis=0.71)

i<-1
while(i<=9){
  
  #asm_enteros
  arrows(x0=i,y0=tiemposMsAsm_enteros[i],x1=i,y1=tiemposMsAsm_enteros[i]+errorMsAsm_enteros[i],angle=90, length=0.1, col="blue", lwd=1)
  arrows(x0=i,y0=tiemposMsAsm_enteros[i],x1=i,y1=tiemposMsAsm_enteros[i]-errorMsAsm_enteros[i],angle=90, length=0.1, col="blue", lwd=1)
  
  #asm_float
  arrows(x0=i,y0=tiemposMsAsm_float[i],x1=i,y1=tiemposMsAsm_float[i]+errorMsAsm_float[i],angle=90, length=0.1, col="orange", lwd=1)
  arrows(x0=i,y0=tiemposMsAsm_float[i],x1=i,y1=tiemposMsAsm_float[i]-errorMsAsm_float[i],angle=90, length=0.1, col="orange", lwd=1)
  
  
  
  #c0
  arrows(x0=i,y0=tiemposMsC0[i],x1=i,y1=tiemposMsC0[i]+errorMsC0[i],angle=90, length=0.1, col="red", lwd=1)
  arrows(x0=i,y0=tiemposMsC0[i],x1=i,y1=tiemposMsC0[i]-errorMsC0[i],angle=90, length=0.1, col="red", lwd=1)
  
  #c3
  arrows(x0=i,y0=tiemposMsC3[i],x1=i,y1=tiemposMsC3[i]+errorMsC3[i],angle=90, length=0.1, col="green", lwd=1)
  arrows(x0=i,y0=tiemposMsC3[i],x1=i,y1=tiemposMsC3[i]-errorMsC3[i],angle=90, length=0.1, col="green", lwd=1)
  
  i=i+1
}




#CODIGO no usado
#mean(  dataexp$clocks[ dataexp$size == tamanos[3]] )   
#tamano1 <-dataexp[ dataexp$size == "128x64", ]   
#tiempo1 <- mean(tamano1$ms)

