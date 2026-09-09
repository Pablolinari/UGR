#!/bin/bash


for archivo in "$PWD"/**; do 

	nombre=$(basename "$archivo")
	if [ "$nombre" = "proteger.sh" ] || [ "$nombre" = "recuperar.sh" ]; 
	then
		continue
	fi

	if [ -f "$archivo" ];then
		echo "protegiendo : $archivo"
		openssl enc -aes128 -pbkdf2 -k "contrasenia" -in $archivo -out $archivo.bin && mv "$archivo".bin $archivo
	fi
done


