extends MeshInstance3D

func crearfigura(n:int,verticesnuevos:PackedVector3Array,indicesnuevos:PackedInt32Array,coloresnuevos:PackedColorArray)->void:
	
	var vertices := PackedVector3Array([Vector3(0,0,0.5), Vector3(0,0,1), Vector3(1,0,0.5), Vector3(1,0,1),
										Vector3(1.1,0.5,0.5), Vector3(1.5, 0.5, 0.5), Vector3(1.5,0,1)])
	var colores := PackedColorArray([Color(0,0,0), Color(0,0,0), Color(0,0,0), Color(0,0,0),
										Color(1,1,1), Color(1,1,1), Color(1,1,1)])
	var indices := PackedInt32Array([0, 2, 1, 2, 3, 1, 2, 4, 3, 4, 5, 6, 4, 6, 3])

	var angulo = TAU/n
	verticesnuevos.append(Vector3(0,0,0.5))
	verticesnuevos.append(Vector3(0,0,1))
	coloresnuevos.append(Color(0,0,0))
	coloresnuevos.append(Color(0,0,0))
	
	for i in range(n):
		for j in range(2,vertices.size()):
			var nx= vertices[j].x*cos(i*angulo)-vertices[j].y*sin(i*angulo)
			var ny =vertices[j].x*sin(i*angulo)+vertices[j].y*cos(i*angulo)
			var nz =vertices[j].z
			verticesnuevos.append(Vector3(nx,ny,nz))
			coloresnuevos.append(colores[j])

	for i in range(n):
		for j in range(6,indices.size()):
			indicesnuevos.append(indices[j]+(5*i))
		indicesnuevos.append_array([0,indices[1]+(5*i),1,indices[1]+(5*i),indices[4]+(5*i),1])


func _ready():
	#var vertices := PackedVector3Array([Vector3(0,0,0.5), Vector3(0,0,1), Vector3(1,0,0.5), Vector3(1,0,1),
										#Vector3(1.1,0.5,0.5), Vector3(1.5, 0.5, 0.5), Vector3(1.5,0,1)])
	#var indices := PackedInt32Array([0, 2, 1, 2, 3, 1, 2, 4, 3, 4, 5, 6, 4, 6, 3])
	#var colores := PackedColorArray([Color(0,0,0), Color(0,0,0), Color(0,0,0), Color(0,0,0),
										#Color(1,1,1), Color(1,1,1), Color(1,1,1)])
	var vertices := PackedVector3Array()
	var colores := PackedColorArray()
	var indices := PackedInt32Array() 
	crearfigura(4,vertices,indices,colores)
	print(vertices.size())
	var tablas : Array = []
	tablas.resize(Mesh.ARRAY_MAX)
	tablas[Mesh.ARRAY_VERTEX] = vertices
	tablas[Mesh.ARRAY_INDEX] = indices
	tablas[Mesh.ARRAY_COLOR] = colores
	
	mesh = ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, tablas)
	
	var mat = StandardMaterial3D.new()
	mat.vertex_color_use_as_albedo = true
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mat.cull_mode = BaseMaterial3D.CULL_DISABLED
	material_override = mat
