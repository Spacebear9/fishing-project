extends StaticBody3D
class_name Bullet
var pos
var target: Vector3
var timestampInstaniated:float
var player: Player
var speed = 200
var lifespan = 2500
var vel
func _spawn(_pos: Vector3, tar: Vector3, _player:Player):
	pos = _pos
	target = tar
	player = _player
func _process(_delta):
	global_position += vel*_delta
	var col = move_and_collide(Vector3.ZERO,true)
	if col && col.get_collider() != player:
		_collide()
	if Time.get_ticks_msec()> timestampInstaniated+lifespan:
		_collide()
		
func _collide():
	queue_free()
func _ready1():
	global_position = pos
	timestampInstaniated = Time.get_ticks_msec()
	vel = global_position.move_toward(target,speed)-global_position
	print(vel.length())
