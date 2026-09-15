#!/bin/bash
# Pablo Linari Pérez
read -p "Contrasenia para cifrar: " encpass 
read -p "Contrasenia para integridad: " macpass 


for archivo in "$PWD"/*; do

	nombre=$(basename "$archivo")

	if [ "$nombre" = "proteger.sh" ] || [ "$nombre" = "recuperar.sh" ];
	then
		continue
	fi

	if [[ "$nombre" == *.hmac ]];
	then
		continue
	fi

	if [ -f "$archivo" ] && [ ! -f "$archivo".hmac ];then
		echo "protegiendo : $archivo"
		openssl enc -aes128 -pbkdf2 -k "$encpass" -in "$archivo" -out "$archivo".bin && mv "$archivo".bin "$archivo"

		openssl dgst -sha256 -hmac "$macpass" "$archivo" > "$archivo".hmac
	fi
done


