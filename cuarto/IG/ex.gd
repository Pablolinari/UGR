
extends Node3D

func cereacasa() ->ArrayMesh:
	
	# 1. VERTICES (Duplicados para permitir diferentes UVs en paredes y tejado)
	var v = PackedVector3Array([
		# --- PAREDES (Cubo 0 a 15) ---
		Vector3(0,0,1), Vector3(0,1,1), Vector3(1,1,1), Vector3(1,0,1), # Frontal
		Vector3(1,0,0), Vector3(0,0,0), Vector3(0,1,0), Vector3(1,1,0), # Trasera
		Vector3(0,0,1), Vector3(0,1,1), Vector3(0,1,0), Vector3(0,0,0), # izq
		Vector3(1,0,1), Vector3(1,0,0), Vector3(1,1,0), Vector3(1,1,1), # der
		
		# --- TEJADO (Pirámide 16 a 27) ---
		Vector3(0,1,1), Vector3(1,1,1), Vector3(0.5,1.8,0.5),#frontal
		Vector3(1,1,1), Vector3(1,1,0), Vector3(0.5,1.8,0.5),#derecha
		Vector3(1,1,0), Vector3(0,1,0), Vector3(0.5,1.8,0.5),#atras
		Vector3(0,1,0), Vector3(0,1,1), Vector3(0.5,1.8,0.5),#izq
		

	])
	
	# 2. TRIÁNGULOS (Índices)
	var indices = PackedInt32Array([
		# Paredes
		0,1,2, 0,2,3,     # Frontal
		4,7,6, 4,6,5,     # Trasera
		13,12,14, 12,15,14,     # Derecha
		8,11,10,8,10,9,     # Izquierda
		# Tejado (Triángulos hacia la punta 12)
		16,18,17,           # Frontal tejado
		19,21,20,          # Derecha tejado
		22,24,23,         # Trasera tejado
		25,27,26           # Izquierda tejado
	])
	
	# 3. UVs (Mapeo según la imagen adjunta)
	# La textura tiene el tejado arriba a la izquierda (0 a 0.33 aprox)
	# Las paredes están en la mitad inferior.
	var uvs = PackedVector2Array()
	uvs.resize(v.size())
	
	# UVs Paredes (Usando la primera ventana de la imagen)
	uvs[0] = Vector2(0.0, 1.0); uvs[1] = Vector2(0.0, 0.5)
	uvs[2] = Vector2(0.25, 0.5); uvs[3] = Vector2(0.25, 1.0)
	
	uvs[15] = Vector2(0.25, 0.5); uvs[12] = Vector2(0.25, 1.0)
	uvs[13] = Vector2(0.5, 1); uvs[14] = Vector2(0.5, 0.5)
	
	uvs[5] = Vector2(0.75, 1); uvs[6] = Vector2(0.75, 0.5)
	uvs[7] = Vector2(0.5, 0.5); uvs[4] = Vector2(0.5, 1)
	
	uvs[10] = Vector2(0.75, 0.5); uvs[9] = Vector2(1, 0.5)
	uvs[11] = Vector2(0.75, 1); uvs[8] = Vector2(1, 1)
	
	uvs[16] = Vector2(0, 0.5); uvs[17] = Vector2(0.25, 0.5); uvs[18]=Vector2(0.125,0)
	uvs[19] = Vector2(0, 0.5); uvs[20] = Vector2(0.25, 0.5); uvs[21]=Vector2(0.125,0)
	uvs[22] = Vector2(0, 0.5); uvs[23] = Vector2(0.25, 0.5); uvs[24]=Vector2(0.125,0)
	uvs[25] = Vector2(0, 0.5); uvs[26] = Vector2(0.25, 0.5); uvs[27]=Vector2(0.125,0)
	
	var meshcasa = ArrayMesh.new()
	var tablas = []
	tablas.resize(ArrayMesh.ARRAY_MAX)
	tablas[Mesh.ARRAY_TEX_UV]=uvs
	tablas[Mesh.ARRAY_VERTEX]=v
	tablas[Mesh.ARRAY_INDEX]=indices
	tablas[Mesh.ARRAY_NORMAL]=Utilidades.calcNormales(v,indices)
	
	meshcasa.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES,tablas)
	
	
	# 5. MATERIAL Y TEXTURA
	var mat = StandardMaterial3D.new()
	mat.albedo_texture = CargarTextura("res://textura.png")
	meshcasa.surface_set_material(0, mat)

	return meshcasa
	
func _ready():
	var m = 4
	for i in range(0,m):
		var mesh_instance = MeshInstance3D.new()
		mesh_instance.mesh=cereacasa()
		mesh_instance.position=Vector3(1*i,0,0)
		mesh_instance.name="casa %i"%i
		var area = Area3D.new()
		area.name="casa"
		var colision = CollisionShape3D.new()
		var  forma = BoxShape3D.new()
		forma.size = Vector3(1, 2, 1)
		colision.shape=forma
		colision.position=Vector3(1*i,0,0)
		area.position=Vector3(1*i,0,0)
		mesh_instance.add_child(colision)
		mesh_instance.add_child(area)
		add_child(mesh_instance)


func CargarTextura( arch : String ) -> ImageTexture :
	## crear un objeto 'Image' con la imgen
	var imagen := Image.new()
	assert( imagen.load(arch) == OK, "Error cargando '"+arch+"'." )
	## crear un objeto 'ImageTexture' a partir del objeto 'Image'
	var textura := ImageTexture.create_from_image( imagen )
	print("Textura cargada desde archivo: '",arch,"'.")
	## devolver la textura
	return textura
