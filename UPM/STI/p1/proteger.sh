#!/bin/bash
# Pablo Linari Pérez
read -p "Contrasenia para descifrar: " descpass
read -p "Contrasenia para descifrar: " macpass 


for archivo in "$PWD"/**; do 

	nombre=$(basename "$archivo")
	if [ "$nombre" = "proteger.sh" ] || [ "$nombre" = "recuperar.sh" ] || [ "$nombre" = "prueba.sh" ]; 
	#if [ "$nombre" = "proteger.sh" ] || [ "$nombre" = "recuperar.sh" ]; 
	then
		continue
	fi

	if [ -f "$archivo" ] && [! -f "$archivo".hmac];then
		echo "protegiendo : $archivo"
		openssl enc -aes128 -pbkdf2 -k "$decpass" -in $archivo -out $archivo.bin && mv "$archivo".bin $archivo

		openssl dgst -sha256 -hmac "$macpass" $archivo > $archivo.hmac
	fi
done


