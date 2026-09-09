192.168..56.101


## lsblk

sda = disco duro 
sdd = disco sata?


## raid

raid = redundant array of independent (inexpensives) disks 

IMPORTANTE PONER LOS DISCOS EN PARALELO PARA MAS EFICIENCIA 

interesan tres niveles estandares : 
- nivel 0 o striping : discos de un tamanio dado y el raid 0 nos crea la virtualizacion cuyo tamanio es igual a la suma de los tamanios . ej(1 +1 +1 = 3) . si 
 se cae uno de los discos se caen todos . ventaja coste y velocidad de acceso , contra sensible a errores 

- nivel1 o mirror: se cogen n discos y crea un disco virtual cuyo tamanio es el minimo del tamanio de los discos que lo componene , siempre que escribes en un disco escribes en todos , proporciona robustez .


- raid 5 : coge n discos y sacrifica el espacio de uno de ellos para almacenar una funcion matematica , si perdemos un disco la funcion de raid 5 es capaz de regenerar lo que se pierde en un disco.Realentiza el acceso ya que por cada acceso se tiene que ejecutar la funcion . 

# dos tipos de implementacion de raid 

raid hardware : cuando tenemos una controladora de raid , tenemos un chip que se encarga de implementar las funciones de raid . ventajas : da buenas prestaciones y es transparente al so . 

raid software : pertenece al so generalmente un driver .


## creando un raid 
1. crear discos en vbox
1.1 instalar mdadm
2. sudo mdadm --create /dev/md0 --level 1 --raid-devices=2 /dev/sdb /dev/sdc

# df -h
disk free (-h lo da en potencias de dos para que se mas facil de leer)

#########

- directorios home y var importante de vigilar 

- du -ks * calcula lo que ocupa cada directorio 

##  comandos importantes 
df
pv 
vg 
lv
mkfs
mount
mdadm
lsblk

## LVM

para solucionar el problema de mover var a particiones se usa lvm para poder cambiar el tamanio de las particiones en caliente . 

- en terminologia de lvm cuando creo un espacio paravar "particion" que no es una particion , creo un volumen logico nuevo 

comando pv para crear volumenes fisicos ?

## modo mantenimiento 

modo1:single user (root) o mantenimiento el que nos interesa ya que echa todos los usr logeados en el sistema y mata a sus procesos y solo deja al root 
modo3: multi user + net
modo5 : modo3 + gui 
modo0:reset , reinicia el sistema 









