extends MeshInstance3D

#change off @export later
var camera: Node3D
var texture = preload("res://scenes/maps/map_objects/water/water.png")
var rect



func _ready():
	camera = auto.player.get_node("Camera3D")
	rect = TextureRect.new()
	rect.texture = texture
	rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(rect)
	rect.hide()

func _process(_delta):
	if camera.global_position.y < global_position.y :
		rect.show()
	else:
		rect.hide()
