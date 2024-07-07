extends MeshInstance3D

func _init():
	RenderingServer.set_debug_generate_wireframes(true)
	var vp = get_viewport()
	vp.debug_draw = (vp.debug_draw + 1 ) % 4
