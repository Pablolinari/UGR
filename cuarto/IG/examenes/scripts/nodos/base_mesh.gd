## Nombre: Pablo, Apellidos: Linari Perez , Titulación: DGIIM
## email: pablolinari@correo.ugr.es, DNI: 75571079W
extends MeshInstance3D

func _ready()->void:
	var meshrail = ArrayMesh.new()
	var vertices:PackedVector3Array =PackedVector3Array([])
	for s in range (0,3):
		for x in [-0.25,0.25]:
			for y in [0,0.1]:
				for z in [-0.4,0.4]:
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
	var normales : PackedVector3Array =Utilidades.calcNormales(vertices,triangulos)
	
	var tablas = []
	tablas.resize(Mesh.ARRAY_MAX)
	tablas[Mesh.ARRAY_VERTEX]=vertices
	tablas[mesh.ARRAY_INDEX]=triangulos 
	tablas[mesh.ARRAY_NORMAL]=normales
	meshrail.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES,tablas)
		
	mesh= meshrail
	var mat :=StandardMaterial3D.new()
	mat.albedo_color=Color.GRAY
	mat.metallic =0.3
	mat.roughness=0.2
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_PER_PIXEL
	material_override = mat
