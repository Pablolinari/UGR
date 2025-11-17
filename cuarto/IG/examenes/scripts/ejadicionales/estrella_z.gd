## Nombre: Pablo, Apellidos: Linari Perez , Titulación: DGIIM
## email: pablolinari@correo.ugr.es, DNI: 75571079W
extends MeshInstance3D

func ArrayMeshEstrella(n:int)->ArrayMesh:
	var meshpoligono = ArrayMesh.new()
	var vertices =PackedVector3Array([])
	var triangulos =PackedInt32Array()
	var colores = PackedColorArray()
	
	
	vertices.append(Vector3(0.5,0.5,0))
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
		var x =vertices[0].x +radio*cos(pasoangulo) 
		var  y=vertices[0].y +radio*sin(pasoangulo)
		
			
			 
		vertices.append(Vector3(x,y,0))
		colores.append(Color(x,y,0))
	
		
		
	
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
	mesh=ArrayMeshEstrella(8)
	var material = StandardMaterial3D.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.vertex_color_use_as_albedo = true
	set_surface_override_material(0, material)
