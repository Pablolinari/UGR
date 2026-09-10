#!/bin/bash
#Pablo Linari Pérez

read -p "Contrasenia para descifrar: " descpass
read -p "Contrasenia para integridad: " macpass 

for archivo in "$PWD"/*; do 
	nombre=$(basename "$archivo")
	if [ "$nombre" = "proteger.sh" ] || [ "$nombre" = "recuperar.sh" ] || [ "$nombre" = "prueba.sh" ] || [[ "$nombre" = *.mac ]]; 
	#if [ "$nombre" = "proteger.sh" ] || [ "$nombre" = "recuperar.sh" ] || [[ "$nombre" = *.mac ]]; 
	then
		continue
	fi

	if [ -f "$archivo" ];then
		echo "recuperando : $archivo"

		hmacoriginal=$(<"$archivo".hmac)
		hmacafter=$(openssl dgst -sha256 -hmac "$macpass" $archivo)

		if [ "$hmacoriginal" == "$hmacafter" ];then
			echo "Integridad Garantizada"
			openssl enc -aes128 -pbkdf2 -k "$decpass" -in $archivo -out $archivo.bin -d && mv "$archivo".bin $archivo
			rm "$archivo".hmac
		else
			echo "No conserva la integridad el archivo: " "$archivo"
			echo "No se desencripta por seguridad" 
		fi

	fi
done


