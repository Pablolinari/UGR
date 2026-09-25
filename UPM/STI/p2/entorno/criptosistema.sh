#!/bin/bash

# Use esta forma de navegar entre los directorios 'remitente', 'canal' y 'destinatario'
cd remitente
printf "Secreto a enviar: %s\n" "$(cat secreto.txt)"
cd ..
# Puede usar cp o mv para enviar archivos entre los directorios

# TO DO: el criptosistema
### generar los parametros dh una sola vez con 3072 , y asumir para la ejecucion que ya existen en remitente/
#genero claves para el destinatario y el remitente

cd destinatario
printf "DESTINATARIO: Genero mi clave privada y pública (RSA) \n"
openssl genrsa -out clave_destinatario_privada.pem 3072
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

cd remitente 
printf "REMITENTE:  Comparto los parametros de Diffie-Hellman (DH)\n"
# asumo que los parametros de dh ya existen en el remitente
cp dh_parametros.pem ../canal/dh_parametros.pem
cd ..

cd destinatario

printf "DESTINATARIO: recibo los parametros para el Diffie-Hellman (DH) \n"
cp ../canal/dh_parametros.pem dh_parametros.pem

printf "DESTINATARIO: Genero mi clave pública y privada y comparto la pública (DH) \n"
openssl genpkey -paramfile dh_parametros.pem -out dh_clave_privada_destinatario.pem
openssl pkey -in dh_clave_privada_destinatario.pem -pubout -out dh_clave_publica_destinatario.pem
cp dh_clave_publica_destinatario.pem ../canal/dh_clave_publica_destinatario.pem
cd ..

cd remitente
printf "REMITENTE: recibo  clave pública (DH)\n"
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
printf "REMITENTE: Encripto el mensaje (AES)\n"
openssl enc -aes-128-cbc -in secreto.txt -out secreto_cifrado.bin -pass file:clave_secreta.hex -pbkdf2

printf "REMITENTE: Genero MAC (DH)\n"

# derivo la clave del MAC pasando el secreto DH por SHA-256
# 
openssl dgst -sha256 -binary -out clave_mac_remitente.bin dh_clave_remitente.bin
openssl dgst -sha256 -mac HMAC -macopt hexkey:"$(od -An -tx1 -v clave_mac_remitente.bin | tr -d ' \n')" secreto_cifrado.bin > secreto_cifrado.bin.hmac

printf "REMITENTE: Envío el secreto encriptado y documento de integridad al destinatario\n"
mv secreto_cifrado.bin ../canal/
mv secreto_cifrado.bin.hmac ../canal/
cd ..

cd destinatario
cp ../canal/secreto_cifrado.bin secreto_cifrado.bin
cp ../canal/secreto_cifrado.bin.hmac secreto_cifrado.bin.hmac

printf "DESTINATARIO: recibo secreto encriptado y documento de integridad \n"
printf "DESTINATARIO: Compruebo la integridad (DH) \n"
# derivo la clave del MAC pasando el secreto DH por SHA-256
openssl dgst -sha256 -binary -out clave_mac_destinatario.bin dh_clave_destinatario.bin
openssl dgst -sha256 -mac HMAC -macopt hexkey:"$(od -An -tx1 -v clave_mac_destinatario.bin | tr -d ' \n')" secreto_cifrado.bin > secreto_cifrado_nuevo.bin.hmac
if cmp -s secreto_cifrado_nuevo.bin.hmac secreto_cifrado.bin.hmac; then
	printf "DESTINATARIO: coinciden los HMAC, integridad garantizada\n"
	printf "DESTINATARIO: desencripto (AES) \n"
	openssl enc -d -aes-128-cbc -in secreto_cifrado.bin -out secreto_descifrado.txt -pass file:clave_secreta.hex -pbkdf2
	printf "Secreto desencriptado: %s\n" "$(cat secreto_descifrado.txt)"
else
	printf "No conserva integridad , no desencripto"
fi
cd ..
