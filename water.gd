extends MeshInstance3D

#change off @export later
var camera: Node3D
var texture




func _ready():
	camera = get_parent().player.get_node("Camera3D")
	texture = get_node("water_png")

func _process(delta):
	if camera.global_position.y < global_position.y:
		texture.show()
	else:
		texture.hide()
