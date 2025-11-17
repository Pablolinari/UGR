## Nombre: Pablo, Apellidos: Linari Perez , Titulación: DGIIM
## email: pablolinari@correo.ugr.es, DNI: 75571079W
extends Node3D

func _crear_cono_y( n : int , dy : float ) -> ArrayMesh :
	
	var pos :  PackedVector3Array = []
	var tri  : PackedInt32Array = []
	
	for i in range(n) :
		var ang_rad : float = (2.0*PI*float(i))/float(n)
		pos.push_back( Vector3( cos(ang_rad) ,dy, -sin(ang_rad) ))
		
	pos.push_back( Vector3( 0.0, 1.0, 0.0 )) ## apice en indice 'n'
	
	for i in range(n) :
		tri.push_back( i ) ; tri.push_back( (i+1)%n ) ; tri.push_back( n )
	var normales = Utilidades.calcNormales(pos,tri)
	## tablas de atributos de v
	var tablas : Array = [] ; tablas.resize( Mesh.ARRAY_MAX ) ## hasta 13 tablas de atributos
	tablas[ Mesh.ARRAY_VERTEX ] = pos
	tablas[ Mesh.ARRAY_INDEX ]  = tri
	tablas[Mesh.ARRAY_NORMAL]=normales
	
	##print("### pos == ", tablas[Mesh.ARRAY_VERTEX])
	##print("### inds == ", tablas[Mesh.ARRAY_INDEX])

	# crear el array mesh en coordenadas maestras, usando las tablas
	var malla_cil := ArrayMesh.new()
	malla_cil.add_surface_from_arrays( Mesh.PRIMITIVE_TRIANGLES, tablas )
	return malla_cil
func ArrayMeshEstrella(n:int)->ArrayMesh:
	var meshpoligono = ArrayMesh.new()
	var vertices =PackedVector3Array([])
	var triangulos =PackedInt32Array()
	var colores = PackedColorArray()
	
	
	vertices.append(Vector3(0,0,0))
	colores.append(Color(1,1,1))
	# Generar vértices
	var angulo = TAU/(2*n)
	var radio = 0.5
	for i in range(2*n):
		if i%2 ==0:
			radio=0.5
		else:
			radio =0.25
			
		var pasoangulo = i*angulo
		var y =vertices[0].x +radio*cos(pasoangulo) 
		var  z=vertices[0].y +radio*sin(pasoangulo)
		
			
			 
		vertices.append(Vector3(0,y,z))
		colores.append(Color(0,y,z))
	
		
		
	
	for i in range(2*n):
		var next = (i + 1) % (2*n)
		triangulos.append(i + 1)
		triangulos.append(0)  
		triangulos.append(next + 1) 
		
		


	var normales : PackedVector3Array = Utilidades.calcNormales(vertices, triangulos) 
	
	
	
	var tablas = []
	tablas.resize(Mesh.ARRAY_MAX)
	tablas[Mesh.ARRAY_VERTEX] = vertices
	tablas[Mesh.ARRAY_INDEX] = triangulos  
	tablas[Mesh.ARRAY_NORMAL] = normales   
	tablas[Mesh.ARRAY_COLOR]=colores


	meshpoligono.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, tablas)

	
	return meshpoligono
func _ready() -> void:
	const N := 8  # Número de puntas de la estrella (mínimo 3)
	var estrella_mesh := ArrayMeshEstrella(N)

	# Crear estrella
	var mesh_inst_estrella := MeshInstance3D.new()
	mesh_inst_estrella.mesh = estrella_mesh
	mesh_inst_estrella.name = "EstrellaMeshInstance"
	
	#var transformacionestrella = Transform3D()
	#transformacionestrella = transformacionestrella.translated(Vector3(-0.5, -0.5, 0))  # compensación
	#mesh_inst_estrella.transform = transformacionestrella
	
	var materialestrella = StandardMaterial3D.new()
	materialestrella.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	materialestrella.vertex_color_use_as_albedo = true
	mesh_inst_estrella.set_surface_override_material(0, materialestrella)
	
	
	
	# Añadir al nodo actual (Node3D)
	add_child(mesh_inst_estrella)
	
	
	var meshcono=_crear_cono_y(32,0.85)
	var material = StandardMaterial3D.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.vertex_color_use_as_albedo = true
	var pasoangulo= TAU/(N)
	for i in range(N):
		var meshaux =MeshInstance3D.new()
		meshaux.mesh=meshcono
		var angulo = i*pasoangulo 
		

		meshaux.set_surface_override_material(0, material)
		
		var transformacion = Transform3D()
		transformacion = transformacion.scaled(Vector3(0.14, 1.0, 0.14))
		transformacion = transformacion.translated(Vector3(0, -0.35, 0))
		transformacion = transformacion.rotated(Vector3(1,0,0), angulo)

		
		meshaux.transform = transformacion
		add_child(meshaux)


@export var activar := "mover_estrella"
@export var rotation_speed := 900    

var activa := true

func _process(delta):
	if Input.is_action_just_pressed(activar):
		activa = !activa

	if activa:
		rotation.x +=deg_to_rad(rotation_speed*delta)
		
