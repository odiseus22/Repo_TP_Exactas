#Aux func
myfunc()
{

  cd ..
  cd ..
  #Borro el log de otras partidas
  rm log/*
  python c_linea.py --red_player ./main $1 $2 $3 $4 --blue_player ./main $5 $6 $7 $8 --first azul --iterations 1
  python c_linea.py --red_player ./main $1 $2 $3 $4 --blue_player ./main $5 $6 $7 $8 --first rojo --iterations 1

  cd Genetico/Results 
  r=`python rojo.py`
  a=`python azul.py`
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

  	myfunc $caso1 $caso2
	f1=$((f1+r))
	f2=$((f2+a))
	myfunc $caso1 $caso3
	f1=$((f1+r))
	f3=$((f3+a))
	myfunc $caso2 $caso3
	f2=$((f2+r))
	f3=$((f3+a))

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
