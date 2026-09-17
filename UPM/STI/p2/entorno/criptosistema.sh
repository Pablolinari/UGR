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

cd destinatario
printf "DESTINATARIO: Genero parámetros y los comparto"
openssl genpkey -genparam -algorithm DH -out dh_parametros.pem -pkeyopt pbits:1024
cp dh_parametros.pem ../canal/dh_parametros.pem

printf"DESTINATARIO: Genero mi clave publica y privada y comparto la publica "
openssl genpkey -paramfile dh_parametros.pem -out dh_clave_privada_destinatario.pem
openssl pkey -in dh_clave_privada_destinatario.pem -pubout -out dh_clave_publica_destinatario.pem
cp dh_clave_publica_destinatario.pem ../canal/dh_clave_publica_destinatario.pem
cd ..

cd remitente
printf "REMITENTE: recibo parámetros y clave pública"
cp  ../canal/dh_parametros.pem dh_parametros.pem
cp  ../canal/dh_clave_publica_destinatario.pem dh_clave_publica_destinatario.pem

printf "REMITENTE: genero mi clave publica y privada"
openssl genpkey -paramfile dh_parametros.pem -out dh_clave_privada_remitente.pem
openssl pkey -in dh_clave_privada_remitente.pem -pubout -out dh_clave_publica_remitente.pem
printf "Genero clave compartida"
openssl pkeyutl -derive -inkey dh_clave_privada_remitente.pem -peerkey dh_clave_publica_destinatario.pem -out material_clave_remitente.bin
cd ..

cd destinatario
printf "DESTINATARIO: Genero clave compartida"

openssl pkeyutl -derive -inkey dh_clave_privada_remitente.pem -peerkey dh_clave_publica_destinatario.pem -out material_clave_remitente.bin
cd ..
#cd remitente 
#printf "REMITENTE: Genero mi clave privada y pública "
#openssl genrsa -out clave_remitente_privada.pem 1024
#openssl rsa -pubout -in clave_remitente_privada.pem -out clave_remitente_publica.pem
#cd ..
#destinatario comparte clave publica


cd destinatario
printf "DESTINATARIO: Comparto mi clave publica\n"
cp clave_destinatario_publica.pem ../canal/
cd ..

cd remitente
printf "REMITENTE: recibo clave de destinatario y encripto "
cp ../canal/clave_destinatario_publica.pem clave_destinatario_publica.pem

openssl pkeyutl -encrypt -pubin -inkey clave_destinatario_publica.pem -in secreto.txt -out secreto_cifrado.bin

printf "REMITENTE: Envio el secreto encriptado al destinatario \n"
mv secreto_cifrado.bin ../canal/
cd ..

cd destinatario
cp ../canal/secreto_cifrado.bin secreto_cifrado.bin
printf "DESTINATARIO: recibo secreto encriptado \n"
openssl pkeyutl -decrypt -inkey clave_destinatario_privada.pem -in secreto_cifrado.bin -out secreto.txt

printf "Secreto desencriptado: %s\n" "$(cat secreto.txt)"
cd ..
