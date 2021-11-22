

#Borrar tests anteriores, para que no se acumulen
rm test/*.txt

#Compilar 
g++ -std=c++11 -o CrearTest CrearTest.cpp


#Crear tests
for i in {3..10}
do
	echo 'caso'-$i-$j
	./CrearTest $i completo > test/'caso'-$i-$j.txt
	

done

