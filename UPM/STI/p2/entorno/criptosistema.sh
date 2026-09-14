#!/bin/bash

# Use esta forma de navegar entre los directorios 'remitente', 'canal' y 'destinatario'
cd remitente
printf "Secreto a enviar: %s\n" "$(cat secreto.txt)"
cd ..
# Puede usar cp o mv para enviar archivos entre los directorios

# TO DO: el criptosistema

#proteger

for archivo in "$PWD"/**; do 

	nombre=$(basename "$archivo")
	if [ "$nombre" = "proteger.sh" ] || [ "$nombre" = "recuperar.sh" ] || [ "$nombre" = "prueba.sh" ]; 
	#if [ "$nombre" = "proteger.sh" ] || [ "$nombre" = "recuperar.sh" ]; 
	then
		continue
	fi

	if [ -f "$archivo" ] && [ ! -f "$archivo".hmac ];then
		echo "protegiendo : $archivo"
		openssl enc -aes128 -pbkdf2 -k "$decpass" -in $archivo -out $archivo.bin && mv "$archivo".bin $archivo

		openssl dgst -sha256 -hmac "$macpass" $archivo > $archivo.hmac
	fi
done

#recuperar
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


cd destinatario
printf "Secreto recibido y verificado: %s\n" "$(cat secreto.txt)"
cd ..
