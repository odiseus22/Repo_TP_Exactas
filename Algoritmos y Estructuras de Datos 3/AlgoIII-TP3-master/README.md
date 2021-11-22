# AlgoIII-TP3
## **Ej. 1:**
* Ejecutar **run_greedy_strategy.sh** dentro de la carpeta _src/tools/_ `sh src/tools/run_greedy_strategy.sh`
* Se puede ejecutar **check_result.py** en la carpeta _src/tools/_ para verificar los resultados.

## **Juez**

El juez esta hecho en la carpeta juez, es una funcion que hace un partida entre dos jugadores y toma los siguientes parametros:

juez(int M,int N,int c, int p, int* jugador1, int* jugador2)
M N c y p son los mismos que el juez normal
Y cada jugador es un array de ints donde jugador[0] = 1 o 2. 
si Jugador[0] = 1 entonces se usa el goloso y se tienen que pasar 4 ints mas en ese arreglo.
Caso contrario, se usa el random, y no es necesario pasar nada mas.

Hay un ejemplo de llamado a la funcion en main.

## **Grid**

Para correr el grid alcanza con entrar en la carpeta, hacer make y ejecutar ./main.
## **Genetico**

Para correr genetico solo se necesita hacer make y ejecutar ./main

Para los tests de genetico se tiene que primero generar genes usando ./test.sh (Esto puede tardar un par de horas, asi que es recomendable usar los genes que ya estan en la carpeta results)

Para obtener los resultados de partidas entre jugadores:./fitnessVS.sh
Para obtener los resultados de partidas con el jugador random(juega 1000 veces por gen de cada caso):./fitnessRandom.sh

## *Tools*
Para correr el jugador goloso contra el random 1000 veces, se debe ejecutar en la carpeta tools run_greedy_strategy.sh
Y luego python check_results.py
