## Nombre: Pablo, Apellidos: Linari Perez , Titulación: DGIIM
## email: pablolinari@correo.ugr.es, DNI: 75571079W
extends Node3D

@export var activar := "mover_brazo1"
@export var rotation_speed := 25.0  # unidades por segundo   

var activa := false

func _process(delta):
	if Input.is_action_just_pressed(activar):
		activa = !activa

	if activa:
		rotation.y +=deg_to_rad(rotation_speed*delta)
		
