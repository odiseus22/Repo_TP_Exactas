# AlgoIII-TP2

## Como ejecutar Ej1:

#### Requerimientos:
- gcc >= 5.3
- Paquete Pillow para Python. `sudo pip install Pillow`

##### Experimentacion:
1. Copiar imagenes a la carpeta `images`: Acepta .png, .jpg y .gif
2. Compilar y ejecutar el main con el siguiente comando: `g++ -o main main.cpp -lstdc++fs -std=c++17 && ./main` (necesita si o si el flag de **lstdc++fs**)
3. Se generaron las imagenes en `results`
##### Funciones catedra:
Compilar y ejecutar el codigo con el siguiente comando: `g++ -o catedra catedra.cpp -lstdc++fs -std=c++17 && ./catedra`
Todas las funciones de este codigo toman input segun lo pedido en la consigna del trabajo.
   
## Como ejecutar ej 2:
1. Compilar el 'main.cpp'
2. Hay que redireccionarle la entrada y la salida
    1. ./main <input.txt > output.txt
 
## Como ejecutar tests aleatorios ej 2:
1) Compilar CrearTest.cpp.  g++ -std=c++11 -o CrearTest CrearTest.cpp
2) Ejecutar Generar_tests. ./Generar_tests.sh argumento (Uno de los siguientes completo random o ralo)
3) Correr: ./Ejecutar.sh
//El resultado se guarda en results en un csv. 
