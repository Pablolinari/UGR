## Nombre: Pablo, Apellidos: Linari Perez , Titulación: DGIIM
## email: pablolinari@correo.ugr.es, DNI: 75571079W
extends MeshInstance3D

func _ready() -> void:
	var meshcilindro = ArrayMesh.new()
	var Vertices2D = PackedVector2Array([
		Vector2(0,0.2),
		Vector2(0.1,0.2),
		Vector2(0.1,-0.2),
		Vector2(0,-0.2)
	])
	var vertices = PackedVector3Array([])
	var triangulos = PackedInt32Array([])
	Utilidades2.generarevolucion(Vertices2D,20,vertices,triangulos)
	var normales = Utilidades.calcNormales(vertices,triangulos)
	
	var tablas = []
	tablas.resize(Mesh.ARRAY_MAX)
	tablas[Mesh.ARRAY_VERTEX]=vertices
	tablas[mesh.ARRAY_INDEX]=triangulos 
	tablas[mesh.ARRAY_NORMAL]=normales
	meshcilindro.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES,tablas)
		
	mesh=meshcilindro
	var mat :=StandardMaterial3D.new()
	mat.albedo_color=Color.BROWN
	mat.metallic =0.3
	mat.roughness=0.2
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_PER_PIXEL
	material_override = mat
