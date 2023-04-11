#!/bin/bash

#INICIALIZACIÓN
nDirectorios=0
nFicheros=0
noCopiado=false
echo "Fecha: $(date)"
echo "Usuario: $(whoami)"
echo -e "Versión del bash: ${BASH_VERSION}\n"

##FUNCION RECURSIVA
function copySelection() {
	for file in $(ls $1);
	do	
		if [ -d "$1/$file" ]; then
			if [ ! -d "$2/$file" ]; then
				mkdir "$2/$file"
				nDirectorios=$(($nDirectorios + 1))
				copySelection "$1/$file" "$2/$file" $3 
			else
				copySelection "$1/$file" "$2/$file" $3
			fi
		else
			ext=$(echo $file | cut -d'.' -f2)
			if [ $ext = $3 ]; then
				if [ ! -e "$2/$file" ] ; then
					nFicheros=$(($nFicheros + 1))
					cp "$1/$file" $2
				else
					noCopiado=true
					echo "$file ya existe"
				fi
			fi
			
		fi
	done

}

####Al llamar al script, los párametros son: dir_origen, dir_destino, ext_fichero1, ext_fichero2,...
if [ $# -lt 3 ] #Si los argumentos son inferiores a 3, sale del programa.
then
	echo "Número de argumentos insuficiente. Error 2"
	exit 2
fi

if [ $# -eq 3 ] #Si los argumentos son iguales a 3
then
	if [ ! -d $1 ]
	then
		echo "El primer argumento no es un directorio válido. Error 2"
		exit 2
	fi
	
	if [ ! -d $2 ]
	then
		echo "El segundo argumento no es un directorio válido. Error 2"
		exit 2
	fi

	dir_origen=$1
	dir_destino=$2
	ext_fichero=$3
fi

if [ $# -gt 3 ] #Si los argumentos son mayores a 3
then
	if [ ! -d $1 ]
	then
		echo "El primer argumento no es un directorio válido. Error 2"
		exit 2
	fi
	
	if [ ! -d $2 ]
	then
		echo "El segundo argumento no es un directorio válido. Error 2"
		exit 2
	fi

	dir_origen=$1
	dir_destino=$2
	ext_fichero=$*

	r1s=$(echo $dir_origen | tr '/' '1')
	r2s=$(echo $dir_destino | tr '/' '1')
	ext_ficheros=$(echo $ext_fichero | tr '/' '1') #Sed da problemas con /, por lo que se cambia el caracter

	ext_ficheros=$(echo $ext_ficheros | sed -e "s/$r1s//") #Elimina la ruta 1
	ext_ficheros=$(echo $ext_ficheros | sed -e "s/$r2s//") #Elimina la ruta 2

	ext_fichero=$ext_ficheros
fi

#ALGORITMO PRINCIPAL
for i in $ext_fichero 
do
	copySelection $dir_origen $dir_destino $i
done

#FINALIZACION DEL PROGRAMA
echo "Se han copiado un total de $nFicheros ficheros."
echo "Se han creado un total de $nDirectorios directorios."

if [ $nFicheros -eq 0 ] #Si nFicheros = 0, no se ha copiado nada
then

	echo "No se ha copiado ningun fichero. Error 2"
	exit 2

fi

if [ $noCopiado = true ] #Ha habido un error en algun momento a la hora de copiar
then

	echo "Ha habido al menos un fichero que no ha sido copiado. Error 1"
	exit 1

fi

if [ $nFicheros -gt 0 ]	#Se ha copiado al menos un fichero
then

	echo "Se han copiado satisfactoriamente los ficheros."
	exit 0
	
fi
