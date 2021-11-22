#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <assert.h>
#include <math.h>

#include "lib.h"


// esto imprime en un archivo el resultado,  modificar luego este test para que sea acorde a la consigna, por ahora aqui guardamos NUESTROS test para debugear cada funcion
void test_lista_nooficial(){
    //test listnew
    printf("%s\n","Test listnew" );

    list_t* lista1 =listNew();

    printf("%s ","deberian ser ambos nulos " );
    printf("%p ", lista1->first);
    printf("%p\n", lista1->last);

    //test addfirst
    printf("%s\n","Test addfirst" );

    int entero1= 42;
    int entero2= 21;
    int entero3= 84;
    int* pe1=&entero1;
    int* pe2=&entero2;
    int* pe3=&entero3;
    listAddFirst(lista1,pe1 );

    printf("%s","deberian ser ambos iguales " );
    printf("%p ", lista1->first);   //veo la direccion de memoria sean las mismas
    printf("%p\n", lista1->last);
  
    listAddFirst(lista1,pe2 );

    printf("%s ", "el primero deberia cambiar");
    printf("%p ", lista1->first);  //veo que la direccion de memoria se van actualizando correctamente
    printf("%p\n", lista1->last);

    listAddFirst(lista1,pe3 );

    printf("%s ", "el primero deberia cambiar");
    printf("%p ", lista1->first);  
    printf("%p\n", lista1->last);


 //   listElem_t*  elem1=lista1->first;
 //   int elem1Data = *((int*)elem1->data);
 //   printf("%d\n", elem1Data);

    printf("%s\n", "la lista deberia ser 84,21,42 la lista es:");
  
    listElem_t* siguiente=lista1->first;
    siguiente=siguiente->next;
    listElem_t* actual=lista1->first;
    int a = *((int*)actual->data);
    printf("%d ", a);
    while(siguiente!=0){
        actual=actual->next;
        siguiente=siguiente->next;
        int a = *((int*)actual->data);
        printf("%d ", a);
    }
    printf("\n");


//provemos lo mismo  con addlast
    printf("%s\n","Test addLast" );
    list_t* lista1b =listNew();


    listAddLast(lista1b,pe1 );

    printf("%s","deberian ser ambos iguales " );
    printf("%p ", lista1b->first);   //veo la direccion de memoria sean las mismas
    printf("%p\n", lista1b->last);
  
    listAddLast(lista1b,pe2 );

    printf("%s ", "el ultimo deberia cambiar");
    printf("%p ", lista1b->first);  //veo que la direccion de memoria se van actualizando correctamente
    printf("%p\n", lista1b->last);

    listAddLast(lista1b,pe3 );

    printf("%s ", "el ultimo deberia cambiar");
    printf("%p ", lista1b->first);  
    printf("%p\n", lista1b->last);

     //printear la lista
    listElem_t* siguienteb=lista1b->first;
    siguienteb=siguienteb->next;
    listElem_t* actualb=lista1b->first;
    int ab = *((int*)actualb->data);
    printf("%p ", actualb->prev); 
    printf("%d ", ab);
    printf("%p ", actualb->next); 
    while(siguienteb!=0){
        actualb=actualb->next;
        siguienteb=siguienteb->next;
        int ab = *((int*)actualb->data);
        printf("%p ", actualb->prev); 
        printf("%d ", ab);
        printf("%p\n", actualb->next); 
    }
    printf("\n");


    //ahora probemos con add
    printf("%s\n","Test add" );

    list_t* lista2 =listNew();
    char* c1 = "a";
    char* c2 = "b";
    char* c3 = "c";
    char* c4 = "d";
    listAdd(lista2,c3,(funcCmp_t*)&strCmp);   //agrega en el orden c,d,a,b,d

    listElem_t* debugListaElem=lista2->first;
    char* debugDataElem= ((char*)debugListaElem->data);
    printf("printear elemento: %s\n ", debugDataElem);
    printf("printear posicion de nodo: %p\n ", debugListaElem);
    printf("printear su anterior esta en: %p\n ", debugListaElem->prev);
    printf("printear su siguiente esta en: %p\n ", debugListaElem->next);
    printf("primero en la lista %p\n ",lista2->first);
    printf("ultimo en la lista %p\n",lista2->last);

    listAdd(lista2,c4,(funcCmp_t*)&strCmp);

    debugListaElem=debugListaElem->next;
    debugDataElem= ((char*)debugListaElem->data);
    printf("printear elemento: %s\n ", debugDataElem);
    printf("printear posicion de nodo: %p\n ", debugListaElem);
    printf("printear su anterior esta en: %p\n ", debugListaElem->prev);
    printf("printear su siguiente esta en: %p\n ", debugListaElem->next);
    printf("primero en la lista %p\n ",lista2->first);
    printf("ultimo en la lista %p\n",lista2->last);

    listAdd(lista2,c1,(funcCmp_t*)&strCmp);

    debugListaElem=debugListaElem->prev;
    debugListaElem=debugListaElem->prev;
    debugDataElem= ((char*)debugListaElem->data);
    printf("printear elemento: %s\n ", debugDataElem);
    printf("printear posicion de nodo: %p\n ", debugListaElem);
    printf("printear su anterior esta en: %p\n ", debugListaElem->prev);
    printf("printear su siguiente esta en: %p\n ", debugListaElem->next);
    printf("primero en la lista %p\n ",lista2->first);
    printf("ultimo en la lista %p\n",lista2->last);

    listAdd(lista2,c2,(funcCmp_t*)&strCmp);  

    debugListaElem=debugListaElem->next;
    debugDataElem= ((char*)debugListaElem->data);
    printf("printear elemento: %s\n ", debugDataElem);
    printf("printear posicion de nodo: %p\n ", debugListaElem);
    printf("printear su anterior esta en: %p\n ", debugListaElem->prev);
    printf("printear su siguiente esta en: %p\n ", debugListaElem->next);
    printf("primero en la lista %p\n ",lista2->first);
    printf("ultimo en la lista %p\n",lista2->last);


    listAdd(lista2,c4,(funcCmp_t*)&strCmp);  //deberia estar en el orden a,b,c,d,d

    debugListaElem=debugListaElem->next;
    debugListaElem=debugListaElem->next;
    debugListaElem=debugListaElem->next;
    debugDataElem= ((char*)debugListaElem->data);
    printf("printear elemento: %s\n ", debugDataElem);
    printf("printear posicion de nodo: %p\n ", debugListaElem);
    printf("printear su anterior esta en: %p\n ", debugListaElem->prev);
    printf("printear su siguiente esta en: %p\n ", debugListaElem->next);
    printf("primero en la lista %p\n ",lista2->first);
    printf("ultimo en la lista %p\n",lista2->last);

 /*   printf("imprimir lista caracteres"); 
    printf("\n");
    listElem_t* siguiente2=lista2->first;
    siguiente2=siguiente2->next;
    listElem_t* actual2=lista2->first; 
    char a2 = *((char*)actual2->data);
    printf("%p ", actualb->prev);
    printf("%s ", a2);
    printf("%p\n", actualb->next);
    while(siguiente2!=0){
        actual2=actual2->next;
        siguiente2=siguiente2->next;
        a2 = *((char*)actual2->data);
        printf("%p ", actualb->prev); 
        printf("%s ", a2);
        printf("%p\n", actualb->next); 
    }
    printf("\n");
*/

    //testear listprint
    // listPrint(list_t* l, FILE *pFile, funcPrint_t* fp), 
    printf("%s\n","test listprint" );
    FILE *Flistprint = fopen("probandolistprint.txt","w");
    listPrint(lista2,Flistprint,(funcPrint_t*)&strPrint);
                                
    fclose(Flistprint);

}

void testLista2 (){
    printf("%s\n","Test clonar y limpiar " );
    list_t* lista1 =listNew();
    char s1[]= "ace";
    char s2[]= "k";
    char s3[]= "hola";
    char* pe1=strClone(s1);
    char* pe2=strClone(s2);
    char* pe3=strClone(s3);
    listAddFirst(lista1,pe1 );
    listAddFirst(lista1,pe2 );
    listAddFirst(lista1,pe3 );
    list_t* nuevaLista=listClone(lista1, (funcDup_t*)&strClone);
    printf("el primero dato de la lista clonada es %s\n", (char *) nuevaLista->first->data );
    listRemoveLast(lista1, (funcDelete_t*)&strDelete);
    listDelete(lista1, (funcDelete_t*)&strDelete);
    listDelete(nuevaLista, (funcDelete_t*)&strDelete);
    

}


void testLista3 (){
    printf("%s\n","Test listRemove" );
    list_t* lista1 =listNew();
   // char s1[]= "ace";
    char s2[]= "k";
    char s7[]= "ace";
    char s3[]= "hola";
   // char s4[]= "ace";
    //char* pe1=strClone(s1);
    char* pe2=strClone(s2);
    char* pe3=strClone(s3);
    //char* pe4=strClone(s4);
    char* pe7=strClone(s7);
    //listAddFirst(lista1,pe1 );
    listAddFirst(lista1,pe2 );
    
    listAddFirst(lista1,pe3 );
    listAddFirst(lista1,pe7 );
    //listAddFirst(lista1,pe4 );
    
    printf("el primero dato de la lista es %s\n", (char *) lista1->first->data );

    printf("el segundo dato de la lista  es %s\n", (char *) lista1->first->next->data );

    printf("el tercer dato de la lista es %s\n", (char *) lista1->first->next->next->data );

    char dataaa[]= "ace";
    char* ptrDataaa=strClone(dataaa);

    listRemove(lista1, ptrDataaa,(funcCmp_t*)&strCmp  ,(funcDelete_t*)&strDelete );

    printf("el primero dato de la lista despues de remove $ ace $ es %s\n", (char *) lista1->first->data );
    
    printf("el segundo dato de la lista despues de remove $ ace $ es %s\n", (char *) lista1->first->next->data );

    listDelete(lista1, (funcDelete_t*)&strDelete);
    
    
    strDelete(ptrDataaa);

}


void testLista4 (){
    //  [6400,640100,640200,640300,640400,640500,640600,640700,
    printf("%s\n","Test listAdd con numeros" );
    list_t* lista1 =listNew();
    char s1[]= "6400";
    char s2[]= "640100";
    char s3[]= "640200";
    char s4[]= "";
    char s5[]= "Laura";
    char* pe1=strClone(s1);
    char* pe2=strClone(s2);
    char* pe3=strClone(s3);
    char* pe4=strClone(s4);
    char* pe5=strClone(s5);
    
    
      
    listAdd(lista1, pe4, (funcCmp_t*)&strCmp );
    listAdd(lista1, pe3, (funcCmp_t*)&strCmp );
    listAdd(lista1, pe2, (funcCmp_t*)&strCmp );
    listAdd(lista1, pe5, (funcCmp_t*)&strCmp );
    listAdd(lista1, pe1, (funcCmp_t*)&strCmp );
    
    
    printf("el primero dato de la lista es %s\n", (char *) lista1->first->data );
    printf("el segundo dato de la lista  es %s\n", (char *) lista1->first->next->data );
    printf("el tercer dato de la lista es %s\n", (char *) lista1->first->next->next->data );
    printf("el cuarto dato de la lista es %s\n", (char *) lista1->first->next->next->next->data );
    printf("el quinto dato de la lista es %s\n", (char *) lista1->first->next->next->next->next->data );
    listDelete(lista1, (funcDelete_t*)&strDelete);
    


}


void testString(){
    char string1[]="hola";
    char* ps1= strClone(string1);
    printf("%s\n", ps1 );
    strDelete(ps1);


}




void test_lista(FILE *pfile){
	list_t* l1= listNew();
	listAdd(l1, strClone("aaaaaaab") ,(funcCmp_t*)&strCmp);
	listAdd(l1, strClone("aaaaaaa") ,(funcCmp_t*)&strCmp);
	listAdd(l1, strClone("babababa") ,(funcCmp_t*)&strCmp);
	listAdd(l1, strClone("aaaaaaabaa") ,(funcCmp_t*)&strCmp);
	listAdd(l1, strClone("aabaaaaaaa") ,(funcCmp_t*)&strCmp);
	listAdd(l1, strClone("c") ,(funcCmp_t*)&strCmp);
	listAdd(l1, strClone("42") ,(funcCmp_t*)&strCmp);
	listAdd(l1, strClone("43") ,(funcCmp_t*)&strCmp);
	listAdd(l1, strClone("zzz") ,(funcCmp_t*)&strCmp);
	listAdd(l1, strClone("zzzz") ,(funcCmp_t*)&strCmp);

	listPrint(l1, pfile, (funcPrint_t*)&strPrint);

	listDelete(l1, (funcDelete_t*)&strDelete);

    fprintf(pfile,"%s\n", "");

}


void test_sorter(FILE *pfile){
    sorter_t* s = sorterNew(5, (funcSorter_t*)&fs_sizeModFive, (funcCmp_t*)&strCmp);
    sorterAdd(s, strClone("a") );
    sorterAdd(s, strClone("ab") );
    sorterAdd(s, strClone("abc") );
    sorterAdd(s, strClone("abcd") );
    sorterAdd(s, strClone("abcde") );


    sorterPrint(s, pfile, (funcPrint_t*)&strPrint);

    sorterDelete(s, (funcDelete_t*)&strDelete);


}

int main (void){
   // test_lista_nooficial();
    FILE *pfile = fopen("salida.caso.propios.txt","w");
    test_lista(pfile);
    test_sorter(pfile);
    fclose(pfile);
    //testLista4();
    return 0;
}


