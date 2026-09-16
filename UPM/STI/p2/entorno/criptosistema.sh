#!/bin/bash

# Use esta forma de navegar entre los directorios 'remitente', 'canal' y 'destinatario'
cd remitente
printf "Secreto a enviar: %s\n" "$(cat secreto.txt)"
cd ..
# Puede usar cp o mv para enviar archivos entre los directorios

# TO DO: el criptosistema

#genero claves para el destinatario y el remitente 

cd destinatario
printf "DESTINATARIO: Genero mi clave privada y pública "
openssl genrsa -out clave_destinatario_privada.pem 1024
openssl rsa -pubout -in clave_destinatario_privada.pem -out clave_destinatario_publica.pem
cd ..

cd remitente 
printf "REMITENTE: Genero mi clave privada y pública "
openssl genrsa -out clave_remitente_privada.pem 1024
openssl rsa -pubout -in clave_remitente_privada.pem -out clave_remitente_publica.pem
cd ..
#destinatario comparte clave publica


cd destinatario
printf "DESTINATARIO: Comparto mi clave publica\n"
cp clave_destinatario_publica.pem ../canal/
cd ..

cd remitente
printf "REMITENTE: recibo clave de destinatario y encripto "
mv ../canal/clave_destinatario_publica.pem .

openssl pkeyutl -encrypt -pubin -inkey clave_destinatario_publica.pem -in secreto.txt -out secreto_cifrado.bin

printf "REMITENTE: Envio el secreto encriptado al destinatario \n"
mv secreto_cifrado.bin ../canal/
cd ..

cd destinatario
mv ../canal/secreto_cifrado.bin .
printf "DESTINATARIO: recibo secreto encriptado \n"
openssl pkeyutl -decrypt -inkey clave_destinatario_privada.pem -in secreto_cifrado.bin -out secreto.txt

printf "Secreto desencriptado: %s\n" "$(cat secreto.txt)"
cd ..
