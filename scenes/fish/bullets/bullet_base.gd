extends StaticBody3D
class_name Bullet
var pos
var target: Vector3
var timestampInstaniated:float
func _spawn(_pos: Vector3, tar: Vector3):
	pos = _pos
	target = tar
func _ready():
	global_position = pos
	timestampInstaniated = Time.get_unix_time_from_system()
func _process(_delta):
	global_position = global_position.move_toward(target,.1)
	var col = move_and_collide(Vector3.ZERO,true)
	if col && col.get_collider() != auto.player:
		queue_free()
	if Time.get_unix_time_from_system()> timestampInstaniated+30:
		queue_free()
