class_name LineHelper

##Returns a Meshinstance3D containing a line between 2 points in 3D space
static var top_layer = 0b10000000

static func create_line(pos1: Vector3, pos2: Vector3,free_signal = null, color = Color.BLACK,on_top = true) -> MeshInstance3D:
	var mesh_instance := MeshInstance3D.new()
	if on_top == true:
		mesh_instance.layers = top_layer
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	mesh_instance.top_level = true
	
	var material := StandardMaterial3D.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = color
	
	var immediate_mesh := ImmediateMesh.new()
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(pos1)
	immediate_mesh.surface_add_vertex(pos2)
	immediate_mesh.surface_end()
	mesh_instance.mesh = immediate_mesh
	
	if free_signal is Signal:
		free_signal.connect(mesh_instance.queue_free.call_deferred)
	
	return mesh_instance
