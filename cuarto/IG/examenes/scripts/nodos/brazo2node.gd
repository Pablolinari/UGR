extends Node3D

@export var activar := "mover_brazo2"
@export var rotation_speed := 6.0 
@export var max_angle := deg_to_rad(180)       
@export var min_angle := deg_to_rad(0)       

var activa := false
var direccion := 1.0

func _process(delta):
	if Input.is_action_just_pressed(activar):
		activa = !activa
	if activa:
		
		if (rotation.x == max_angle):
			direccion=-1.0
		if(rotation.z==min_angle):
			direccion=1.0
		rotation.z += direccion*deg_to_rad(rotation_speed*delta)
		
		# limita el rango de movimiento 
		
		


		
