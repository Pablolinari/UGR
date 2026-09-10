
#!/bin/bash


read -p "Contrasenia para descifrar: " descpass

for archivo in "$PWD"/*; do 
	nombre=$(basename "$archivo")
	if [ "$nombre" = "proteger.sh" ] || [ "$nombre" = "recuperar.sh" ] || [ "$nombre" = "recuperar.sh" ] || [[ "$nombre" = *.mac ]]; 
	then
		continue
	fi

	if [ -f "$archivo" ];then
		echo "recuperando : $archivo"
		openssl enc -aes128 -pbkdf2 -k "$decpass" -in $archivo -out $archivo.bin -d && mv "$archivo".bin $archivo
	fi

done


