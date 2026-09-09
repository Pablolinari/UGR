#!/bin/bash

if [ $# -eq 0 ];then
	echo "Hay que indicar la contrasenia"
	echo "La contrasenia es: contrasenia"
	exit 1
fi

for archivo in "$PWD"/*; do 
	
	nombre=$(basename "$archivo")
	if [ "$nombre" = "proteger.sh" ] || [ "$nombre" = "recuperar.sh" ]; 
	then
		continue
	fi
	if [ -f "$archivo" ];then
		echo "recuperando : $archivo"
		openssl enc -aes128 -pbkdf2 -k "$1" -in $archivo -out $archivo.bin -d && mv "$archivo".bin $archivo
	fi
done


