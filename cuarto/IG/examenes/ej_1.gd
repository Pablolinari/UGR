extends MeshInstance3D

func _ready() -> void:
	var meshej1 =ArrayMesh.new()
	var vertices = PackedVector3Array([Vector3(1,0,0),
	Vector3(2,0,0),Vector3(3,1,0),Vector3(4,0,0),Vector3(5,0,0),
	Vector3(0,0,1),Vector3(1.75,0,1),Vector3(2.75,1,1),Vector3(3.75,0,1),Vector3(4.75,0,1)])
	
	var triangulos = PackedInt32Array(
		[0,1,6, 0,6,5,
		1,2,7, 1,7,6,
		2,3,7, 7,3,8,
		3,4,8, 8,4,9]
	)
	var colores = PackedColorArray()
	
	for v in vertices :
		colores.append(Color(v.x,v.y,v.z))
		
	var tablas =[]
	tablas.resize(Mesh.ARRAY_MAX)
	
	tablas[Mesh.ARRAY_COLOR] =colores
	tablas[Mesh.ARRAY_VERTEX]=vertices
	tablas[Mesh.ARRAY_INDEX]=triangulos
	
	meshej1.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES,tablas)
	
	mesh=meshej1
	
	
	var material = StandardMaterial3D.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.vertex_color_use_as_albedo = true
	set_surface_override_material(0, material)
	
