## Nombre: Pablo, Apellidos: Linari Perez , Titulación: DGIIM
## email: pablolinari@correo.ugr.es, DNI: 75571079W
extends Node3D

@export var activar := "mover_brazo2"
@export var rotation_speed := 30.0 
@export var max_angle := 190       
@export var min_angle := -10       

var activa := false
var direccion := 1.0
var angulo=0
func _process(delta):
	if Input.is_action_just_pressed(activar):
		activa = !activa
	if activa:
		angulo+= direccion * rotation_speed * delta
		if (angulo >= max_angle ):
			direccion=-1.0
		if(angulo <= min_angle ):
			direccion=1.0
		rotation.z =deg_to_rad(angulo)
		



		
