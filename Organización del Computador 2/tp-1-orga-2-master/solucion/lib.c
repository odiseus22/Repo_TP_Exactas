#include "lib.h"

/** STRING **/

void hexPrint(char* a, FILE *pFile) {
    int i = 0;
    while (a[i] != 0) {
        fprintf(pFile, "%02hhx", a[i]);
        i++;
    }
    fprintf(pFile, "00");
}

/** Lista **/

void listRemove(list_t* l, void* data, funcCmp_t* fc, funcDelete_t* fd){
	listElem_t *actual = l->first;
	
	while(actual != NULL){
		if(fc(actual->data, data) == 0){
			//tengo que borrar el nodo
			//borro la data primero
			if(*fd!=NULL) fd(actual->data);
		
			listElem_t *anterior = actual->prev;
			listElem_t *siguiente = actual->next;
			if (l->first == l->last && l->last== actual){
				free(actual);
				l->first=NULL;
				l->last=NULL;
				break;
			}
			else if(actual == l->first ){
				siguiente->prev=NULL;
				l->first= siguiente;
				free(actual);
				actual = l->first;
			}
			else if(actual == l->last ){
				anterior->next=NULL;
				l->last=anterior;
				free(actual);
				actual= NULL;
			}
			// ningun caso borde
			else {
				anterior->next=siguiente;
				siguiente->prev=anterior;
				free(actual);
				actual=siguiente;

			}

		}
		else actual=actual->next;
	}
}




void listRemoveFirst(list_t* l, funcDelete_t* fd){
	listElem_t *primerNodo = l->first;
	

	if(primerNodo != 0){

		if(l->last == primerNodo){

			if(*fd!=NULL) fd(primerNodo->data);
			free(primerNodo);
			l->first=NULL;
			l->last=NULL;
			
		}
		else {
			if (primerNodo != NULL){

				listElem_t *segundoNodo = primerNodo->next;

				if(*fd!=NULL) fd(primerNodo->data);
						
						free(primerNodo);
						
						l->first=segundoNodo;
						segundoNodo->prev= NULL ;
	    }
	}
} else {
	
}
}







void listRemoveLast(list_t* l, funcDelete_t* fd){
	listElem_t *ultimoNodo = l->last;
	
	if(ultimoNodo != 0){
		if(l->first == ultimoNodo){

			if(*fd!=NULL) fd(ultimoNodo->data);
			free(ultimoNodo);
			l->first=NULL;
			l->last=NULL;
			
	}
	else {
		if (ultimoNodo != NULL){
			listElem_t *anteUltimo = ultimoNodo->prev;
			if(*fd!=NULL) fd(ultimoNodo->data);
		
			free(ultimoNodo);
			
			l->last=anteUltimo;
			anteUltimo->next= NULL ;
	    }

	}
 }else{
 	
 }
}
