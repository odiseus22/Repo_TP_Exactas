

#Borrar tests anteriores, para que no se acumulen
rm test/*.txt

#Compilar 
g++ -std=c++11 -o CrearTest CrearTest.cpp


#Crear tests
for i in {3..6}
do
	for j in {1..10}
	do
		echo 'caso'-$i-$j
	 	./CrearTest $i random > test/'caso'-$i-$j.txt
	done

done

