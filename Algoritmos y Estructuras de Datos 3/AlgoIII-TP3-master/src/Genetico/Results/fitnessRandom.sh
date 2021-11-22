#Aux func
myfunc()
{

  cd ..
  cd ..
  #Borro el log de otras partidas
  rm log/*
  python c_linea.py --red_player ./main $1 $2 $3 $4 --blue_player ./random_player --first azul --iterations 500
  python c_linea.py --red_player ./main $1 $2 $3 $4 --blue_player ./random_player --first rojo --iterations 500

  cd Genetico/Results 
  r=`python rojo.py`

  echo $r
}




# opening explicitly, since even if opened on the loop, these need
# to be explicitly closed.
exec {fd_1}<"$1"
exec {fd_2}<"$2"
exec {fd_3}<"$3"

f1=0
f2=0
f3=0
while read -r -u "$fd_1" caso1 \
   && read -r -u "$fd_2" caso2 && read -r -u "$fd_3" caso3; do
  	
  	echo $caso1
  	echo $caso2
  	echo $caso3

  	myfunc $caso1
	f1=$((f1+r))	
	myfunc $caso2 
	f2=$((f2+r))	
	myfunc $caso3
	f3=$((f3+r))

done

# close the files explicitly
exec {fd_1}>&- {fd_2}>&- {fd_3}>&-


#while IFS= read -r line; do
  

  #echo "$linea" 
 # echo "tester: $line"
#done < "$1 $2 $3"



echo $f1 
echo $f2
echo $f3
