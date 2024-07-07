extends StaticBody3D
class_name Bullet
var pos
var target: Vector3

func _spawn(_pos: Vector3, tar: Vector3):
	pos = _pos
	target = tar
func _ready():
	global_position = pos

func _process(_delta):
	global_position = global_position.move_toward(target,1)
