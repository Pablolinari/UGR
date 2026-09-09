## firewall 
- lo implementa el iptables en linux 
- nmap para escanear puertos
 

## comandos 

firewall-cmd --state 
firewall-cmd --list-all 


aladir un nuevo servicio

firewall-cmd --add-service http 

para hacerlo permanente 

firewall-cmd --runtime-to-permanent

firewall-cmd --add-service http --permanent # lo aniade a disco pero no se activa , hay que usar la opcion reload 

## SSH mas importante 

- es una aplicacion de terminal remoto seguro 
- antes se usaba telnet que no era seguro , si habia un man in the middle podia ver todo el trafico no solo el login  y el password .
- ssh user@ip abre un login del usuario user en la ip
- tanto el login como la sesion son encriptados 
### Criptografia 



- llave simetrica : misma llave para encriptar y desencriptar , ambo usuarios la conocen
 - escala muy mal cuando hay muchos usuarios 
  - si la llave se compromete , todos los usuarios se comprometen 



- llave asimetrica : una llave para encriptar y otra para desencriptar 
  - una llave publica y una privada 
  - la publica se puede compartir con todos 
  - la privada se guarda en el servidor 
  - se puede encriptar con la publica y solo se puede desencriptar con la privada 
  - se puede firmar con la privada y solo se puede verificar con la publica 
  - lo que cifras con una llave lo descifras con otra .
  - si conocen tu llave publica se puede comunicar de forma segura contigo usandola para cifrar el mensaje y solo el duenio de la llave privada puede descifrarlo. 

 - la llave privada se puede usar para firmar . 
- la firma digital es un hash cifrado con la llave privada 

## conectandonos por ssh 
# conectarse con la llave privada (no hay que poner contraseña)

- si la llave publica esta en el servidor , el servidor sabe que la llave privada es la que se esta conectando . manda un challenge y la llave privada lo firma y lo manda de vuelta.

# generando llave publica y privada en rocky 

comandos : 
ssh-keygen 
ssh-agent dura hasta que se cierra la sesion  es para no tener que estar continuamente metiendo la contraseña 


# ejercicio 

- para modificar el puerto vamos a /etc/ssh
- sshd (es el demon) es de sevidor y ssh de cliente 
- elegimos el sshd_config y cambiamos el puerto y poner el comando que indica el comentario , reiniciar sshd y ver el firewall 

- para conectarse habra que indicar el puerto con -p



















