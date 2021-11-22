

#Borrar tests anteriores, para que no se acumulen
rm test/*.txt

#Compilar 
g++ -std=c++11 -o CrearTest CrearTest.cpp


#Crear tests
for i in {8..30}
do

	echo 'caso'-$i-$j
 	./CrearTest 9 "a" $i > test/'caso'-$i.txt


done

