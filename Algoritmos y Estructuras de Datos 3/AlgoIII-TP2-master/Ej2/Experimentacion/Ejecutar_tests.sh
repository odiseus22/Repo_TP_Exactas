


cd .. 
##Limpiar los resultados anteriores
echo > Experimentacion/Results/Dijkstra.csv
echo > Experimentacion/Results/Dijkstra_FIFO.csv
echo > Experimentacion/Results/Bellman-Ford.csv
echo > Experimentacion/Results/Floyd-Warshall.csv

 g++ -std=c++11 -o ejec main.cpp



for file in  Experimentacion/test/*.txt; do
	echo $file
	./ejec Dijkstra < $file >> Experimentacion/Results/Dijkstra.csv
	./ejec Dijkstra_FIFO < $file >>  Experimentacion/Results/Dijkstra_FIFO.csv
	./ejec Bellman-Ford < $file >>  Experimentacion/Results/Bellman-Ford.csv
	./ejec Floyd-Warshall < $file >>  Experimentacion/Results/Floyd-Warshall.csv
done
