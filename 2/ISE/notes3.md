## andible 

nodos controladores  : nuestro equipo desde donde
mandamos las ordenes a los servidores , este se llam
nodo controlador y es el unico en el que hay que tener instalado ansible

nodos manejados : se necesita  tener python y ssh disponible 

- se corre como usuario normal , es una herramienta de desarrollo 
- si una ip no esta en el archivo de inventario no se puede mandar comandos 

- se pueden etiquetar los servidores 

- para ejecutar comandos sueltos hacemos : ansible nombre equipo -m modulo -a 'cosas ' #mirar bien

- no es aconsejable abusar de los comandos de shell con ansible 
ya que varian con la version , la shell y varias cosas mas . 


# como hacer que un user se convierta en super user 
# sin contrasenia 

- en etc/sudoers contiene la config de como los usuarios pueden pasar a super usuario 

- cambiar grupo wheel por el usuario que queramos 
- hay que usar visudo para hacer los cambios 


- para ejecutar :
ansible-playblook -i inventario "hosts.yaml" playbookaejecutar

- crear un script en bash para ejecutar la linea que queremos 

# ejercicio obligatorio  

- permitir que el root se conecte por ssh sin contrasenia y dejarlo listo par que se pueda usar ansible 

- para eso hay que modificar la config de sshd y cambiar la linea de permitrootlogin 


- hay que hacer del 1 al 5 en un playbook de ansible 








