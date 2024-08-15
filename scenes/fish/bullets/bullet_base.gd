extends StaticBody3D
class_name Bullet
var pos
var target: Vector3
var timestampInstaniated:float
var player: Player
func _spawn(_pos: Vector3, tar: Vector3, _player:Player):
	pos = _pos
	target = tar
	player = _player
func _ready():
	global_position = pos
	timestampInstaniated = Time.get_unix_time_from_system()
func _process(_delta):
	global_position = global_position.move_toward(target,.1)
	var col = move_and_collide(Vector3.ZERO,true)
	if col && col.get_collider() != player:
		queue_free()
	if Time.get_unix_time_from_system()> timestampInstaniated+30:
		queue_free()
