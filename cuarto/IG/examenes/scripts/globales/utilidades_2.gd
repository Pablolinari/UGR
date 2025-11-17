extends Node

func generarevolucion(perfil: PackedVector2Array, copias: int, 
					  vertices: PackedVector3Array, triangulos: PackedInt32Array) -> int:
	vertices.clear()
	triangulos.clear()
	
	var n_puntos = perfil.size()
	
	# Generar vértices
	for i in range(copias):
		var angulo = (float(i) / copias) * TAU
		
		for j in range(n_puntos):
			var x = perfil[j].x
			var y = perfil[j].y
			
			var x_rot = x * cos(angulo)
			var z_rot = x * sin(angulo)
			vertices.append(Vector3(x_rot, y, z_rot))
	
	# --- Generar triángulos (SENTIDO ANTIHORARIO) ---
	for i in range(copias):
		var i1 = i
		var i2 = (i + 1) % copias  # Conectar último con primero
		
		for j in range(n_puntos - 1):
			var v00 = i1 * n_puntos + j
			var v01 = i1 * n_puntos + j + 1
			var v10 = i2 * n_puntos + j
			var v11 = i2 * n_puntos + j + 1
			
			# Triángulo 1: v00 → v01 → v10  (antihorario)
			triangulos.append(v00)
			triangulos.append(v01)
			triangulos.append(v10)
			
			# Triángulo 2: v01 → v11 → v10  (antihorario)
			triangulos.append(v01)
			triangulos.append(v11)
			triangulos.append(v10)
	

	return 0
