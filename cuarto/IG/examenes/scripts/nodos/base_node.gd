## Nombre: Pablo, Apellidos: Linari Perez , Titulación: DGIIM
## email: pablolinari@correo.ugr.es, DNI: 75571079W
extends Node3D

@export var activar := "mover_base"
@export var translation_speed := 1.0  # unidades por segundo (ajusta a gusto)
@export var max_distance := 3.0       # límite de movimiento (opcional)
@export var min_distance := -3.0       # límite mínimo

var activa := false
var direccion := 1.0  # 1 = adelante, -1 = atrás

func _process(delta):
	if Input.is_action_just_pressed(activar):
		activa = !activa

	if activa:
		# Mover en el eje Z local
		if (position.x == max_distance):
			direccion=-1.0
		if(position.x==min_distance):
			direccion=1.0
		position.x += translation_speed * direccion * delta
		
		# Opcional: limitar el rango
		position.x = clamp(position.x, min_distance, max_distance)
		
