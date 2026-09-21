#!/bin/bash

# Use esta forma de navegar entre los directorios 'remitente', 'canal' y 'destinatario'
cd remitente
printf "Secreto a enviar: %s\n" "$(cat secreto.txt)"
cd ..
# Puede usar cp o mv para enviar archivos entre los directorios

# TO DO: el criptosistema

#genero claves para el destinatario y el remitente

cd destinatario
printf "DESTINATARIO: Genero mi clave privada y pública (RSA) \n"
openssl genrsa -out clave_destinatario_privada.pem 512 #3072
openssl rsa -pubout -in clave_destinatario_privada.pem -out clave_destinatario_publica.pem
printf "DESTINATARIO: Comparto mi clave pública (RSA)\n"
cp  clave_destinatario_publica.pem ../canal/clave_destinatario_publica.pem
cd ..

cd remitente
printf "REMITENTE: recibo clave de destinatario (RSA) \n"
cp ../canal/clave_destinatario_publica.pem clave_destinatario_publica.pem
printf "REMITENTE: genero clave simetrica  y la encripto(RSA) \n"
openssl rand -hex 16 > clave_secreta.hex
openssl pkeyutl -encrypt -pubin -inkey clave_destinatario_publica.pem -in clave_secreta.hex -out clave_secreta.hex.bin

printf "REMITENTE: comparto la clave cifrada(RSA) \n"
cp clave_secreta.hex.bin ../canal/clave_secreta.hex.bin
cd ..

cd destinatario
printf "DESTINATARIO: Recibo la clave cifrada (RSA)\n"
cp ../canal/clave_secreta.hex.bin clave_secreta.hex.bin
printf "DESTINATARIO: Descifro la clave (RSA)\n"
openssl pkeyutl -decrypt -inkey clave_destinatario_privada.pem -in clave_secreta.hex.bin -out clave_secreta.hex
cd ..

cd destinatario
printf "DESTINATARIO: Genero parámetros y los comparto (DH)\n"
### preguntar : tarda mcho por que , puedo bajerle los bits 
openssl genpkey -genparam -algorithm DH -out dh_parametros.pem -pkeyopt pbits:512 ##3072
cp dh_parametros.pem ../canal/dh_parametros.pem

printf "DESTINATARIO: Genero mi clave pública y privada y comparto la pública (DH) \n"
openssl genpkey -paramfile dh_parametros.pem -out dh_clave_privada_destinatario.pem
openssl pkey -in dh_clave_privada_destinatario.pem -pubout -out dh_clave_publica_destinatario.pem
cp dh_clave_publica_destinatario.pem ../canal/dh_clave_publica_destinatario.pem
cd ..

cd remitente
printf "REMITENTE: recibo parámetros y clave pública (DH)\n"
cp  ../canal/dh_parametros.pem dh_parametros.pem
cp  ../canal/dh_clave_publica_destinatario.pem dh_clave_publica_destinatario.pem

printf "REMITENTE: genero mi clave pública y privada (DH)\n"
openssl genpkey -paramfile dh_parametros.pem -out dh_clave_privada_remitente.pem
openssl pkey -in dh_clave_privada_remitente.pem -pubout -out dh_clave_publica_remitente.pem
printf "REMITENTE: comparto mi clave pública (DH)\n"
cp dh_clave_publica_remitente.pem ../canal/dh_clave_publica_remitente.pem
printf "REMITENTE: Genero clave compartida (DH)\n"
openssl pkeyutl -derive -inkey dh_clave_privada_remitente.pem -peerkey dh_clave_publica_destinatario.pem -out dh_clave_remitente.bin
cd ..

cd destinatario
printf "DESTINATARIO: Recibo clave pública (DH)\n"
cp ../canal/dh_clave_publica_remitente.pem dh_clave_publica_remitente.pem
printf "DESTINATARIO: Genero clave compartida (DH)\n"
openssl pkeyutl -derive -inkey dh_clave_privada_destinatario.pem -peerkey dh_clave_publica_remitente.pem -out dh_clave_destinatario.bin
cd ..


cd remitente
printf "REMITENTE: Encripto el mensaje (RSA)\n"
openssl enc -aes-256-cbc -in secreto.txt -out secreto_cifrado.bin -pass file:clave_secreta.hex -pbkdf2

printf "REMITENTE: Genero MAC (DH)\n"
openssl dgst -sha256 -mac HMAC -macopt hexkey:"$(od -An -tx1 dh_clave_remitente.bin | tr -d ' \n')" secreto_cifrado.bin > secreto_cifrado.bin.hmac

printf "REMITENTE: Envío el secreto encriptado y documento de integridad al destinatario\n"
mv secreto_cifrado.bin ../canal/
mv secreto_cifrado.bin.hmac ../canal/
cd ..

cd destinatario
cp ../canal/secreto_cifrado.bin secreto_cifrado.bin
cp ../canal/secreto_cifrado.bin.hmac secreto_cifrado.bin.hmac

printf "DESTINATARIO: recibo secreto encriptado y documento de integridad \n"
printf "DESTINATARIO: Compruebo la integridad (DH) \n"
openssl dgst -sha256 -mac HMAC -macopt hexkey:"$(od -An -tx1 dh_clave_destinatario.bin | tr -d ' \n')" secreto_cifrado.bin > secreto_cifrado_nuevo.bin.hmac
if cmp -s secreto_cifrado_nuevo.bin.hmac secreto_cifrado.bin.hmac; then
	printf "DESTINATARIO: coinciden los HMAC, integridad garantizada\n"
	printf "DESTINATARIO: desencripto (RSA) \n"
	openssl enc -d -aes-256-cbc -in secreto_cifrado.bin -out secreto_descifrado.txt -pass file:clave_secreta.hex -pbkdf2
	printf "Secreto desencriptado: %s\n" "$(cat secreto_descifrado.txt)"
fi
cd ..
