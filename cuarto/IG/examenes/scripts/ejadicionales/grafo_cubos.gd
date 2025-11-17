## Nombre: Pablo, Apellidos: Linari Perez , Titulación: DGIIM
## email: pablolinari@correo.ugr.es, DNI: 75571079W
extends Node3D
func ArrayMeshRejilla( m: int, n: int ) -> ArrayMesh:
	var meshrejilla = ArrayMesh.new()
	var pasox:float = float(1)/float(m-1)
	var pasoz:float = float(1)/float(n-1)
	
	var vertices = PackedVector3Array([])
	var normales = PackedVector3Array([])
	var triangulos =PackedInt32Array()
	var colores = PackedColorArray()
	var x = -pasox
	var z = -pasoz

	for i in range(m):
		x = x+pasox
		z = -pasoz
		for j in range(n):
			z= z+pasoz
			vertices.append(Vector3(x,0,z))
			colores.append(Color(x,0,z))
			normales.append(Vector3(0,1,0))
	
	for i in range((n*m)-n):
		if (i+1)%n ==0:
			pass
		else:
			triangulos.append(i)
			triangulos.append(i+n)
			triangulos.append(i+n+1)
			
			triangulos.append(i)
			triangulos.append(i+n+1)
			triangulos.append(i+1)
	
	var tablas = []
	tablas.resize(Mesh.ARRAY_MAX)
	tablas[Mesh.ARRAY_VERTEX] = vertices
	tablas[Mesh.ARRAY_INDEX] = triangulos     
	tablas[Mesh.ARRAY_COLOR]=colores
	tablas[Mesh.ARRAY_NORMAL]=normales


	meshrejilla.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, tablas)
		
	
	return meshrejilla

func ArrayMeshCubo24() -> ArrayMesh:
	var meshnueva = ArrayMesh.new()
	
	var vertices: PackedVector3Array = PackedVector3Array([])
	for s in range(0,3):
		for x in [-0.5,0.5]:
			for y in [0,1]:
				for z in [-0.5,0.5]:
					vertices.append(Vector3(x,y,z))
	

	var triangulos = PackedInt32Array([
			# Cara izq
			0,2,3,   0,3,1,
			# Cara frontal
			11,5,9,   11,7,5,
			# Cara derecha 
			15,6,4,  4,13,15,
			# Cara superior 
			10,14,23,  23,19,10,
			# Cara de atras 
			22,18,8,   8,12,22,
			# Cara de abajo
			16,17,21 , 21,20,16
		])
	# Calcular normales USANDO LOS TRIÁNGULOS (no aristas)
	var normales : PackedVector3Array = Utilidades.calcNormales(vertices, triangulos)  # Asume función corregida
	
	# Arrays para el mesh
	var tablas = []
	tablas.resize(Mesh.ARRAY_MAX)
	tablas[Mesh.ARRAY_VERTEX] = vertices
	tablas[Mesh.ARRAY_INDEX] = triangulos  # Usa triángulos, no aristas
	tablas[Mesh.ARRAY_NORMAL] = normales   # Normales por vértice
	
	# Crear superficie con TRIÁNGULOS (para cubo sólido)
	meshnueva.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, tablas)
	
	return meshnueva
	
func _ready() -> void:
	var cuborejilla = Node3D.new()
	var meshrejilla = ArrayMeshRejilla(7,7)
	var meshcubo = ArrayMeshCubo24()
	var material = StandardMaterial3D.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.vertex_color_use_as_albedo = true
	material.cull_mode=BaseMaterial3D.CULL_DISABLED
	
	
	for i in range(6):
		var meshauxrejilla =MeshInstance3D.new()
		var meshauxcubo =MeshInstance3D.new()
		meshauxcubo.mesh=meshcubo
		meshauxrejilla.mesh=meshrejilla
		var transformacionrejilla =Transform3D()
		var transformacioncubo =Transform3D()
		var angulo = i *(TAU/4)
		var x=1
		var z=0
		if i == 4:
			angulo =deg_to_rad(270)
			z=1
			x=0
		if i == 5:
			angulo =PI/2
			z=1
			x=0
				## TRANSFORMACIONES CUBO
			
		#transformacioncubo = transformacioncubo.translated(Vector3(-0.5,0.5,-0.5))
		#transformacioncubo = transformacioncubo.scaled(Vector3(0.4,0.8,0.4))
		#transformacioncubo =transformacioncubo.rotated(Vector3(x,0,z),angulo)
		
		meshauxcubo.transform = transformacioncubo

		meshauxcubo.scale= Vector3(0.5,0.8,0.5)
		meshauxcubo.position = (Vector3(0.5,0,0.5))
		meshauxcubo.set_surface_override_material(0,material)
		meshauxrejilla.add_child(meshauxcubo)
		
		## TRANSFORMACIONES REJILLA 
		transformacionrejilla = transformacionrejilla.translated(Vector3(-0.5,0.5,-0.5))
		transformacionrejilla =transformacionrejilla.rotated(Vector3(x,0,z),angulo)
		meshauxrejilla.transform =transformacionrejilla
		meshauxrejilla.set_surface_override_material(0, material)
		add_child(meshauxrejilla)

		
@export var tecla_activar := "mover_cubos"
@export var velocidad_rotacion := 10.0

var rotando := false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed(tecla_activar):
		rotando = !rotando
	
	if rotando:
		for hijo in get_children():
			hijo.get_child(0).rotate(Vector3(0,1,0),velocidad_rotacion*delta)
