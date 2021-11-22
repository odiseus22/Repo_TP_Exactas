#Aux func
myfunc()
{

  cd ..
  #Borro el log de otras partidas
  rm log/*
  python c_linea.py --red_player ./main $1 $2 $3 $4 --blue_player ./main $5 $6 $7 $8 --first azul --iterations 1
  python c_linea.py --red_player ./main $1 $2 $3 $4 --blue_player ./main $5 $6 $7 $8 --first rojo --iterations 1

  cd Genetico  
  r=`python winner.py`

  echo $r
}


caso1=0
caso2=0
caso3=0
echo > Results/caso1.txt
echo > Results/caso2.txt
echo > Results/caso3.txt


#Run coda
make
for j in {0..4}
do
	for i in {1..50..5}
	do
	    echo "iteracion: $i"
		k=$((10*$i))
		echo $k
		x=`./main $k 1` 
		y=`./main $k 2`
		z=`./main $k 3`
		
		myfunc $x $y
		caso1=$((r+caso1))
		caso2=$((2-r+caso2))
		myfunc $x $z
		caso1=$((r+caso1))
		caso3=$((2-r+caso3))
		myfunc $y $z
		caso2=$((r+caso2))
		caso3=$((2-r+caso3))

		#Guardo genes
		echo $caso1 >> Results/caso1.txt
		echo $caso2 >> Results/caso2.txt
		echo  $caso3 >> Results/caso3.txt

	done
done



echo $caso1
echo $caso2
echo $caso3
