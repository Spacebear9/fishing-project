extends RigidBody3D
class_name Bullet
var pos
var target: Vector3
var timestampInstaniated:float
var player: Player
var speed = 200
var lifespan = 2500
var vel
var cont
func _spawn(_pos: Vector3, tar: Vector3, _player:Player):
	pos = _pos
	target = tar
	player = _player
	cont = true
func _process(_delta):
	_process1(_delta)
		
func _collide():
	queue_free()
func _ready1():
	while !cont == true:
		pass
	global_position = pos
	timestampInstaniated = Time.get_ticks_msec()
	vel = global_position.move_toward(target,speed)-global_position
	vel = vel.normalized() * speed

func _process1(delta1):
	position += vel*delta1
	var col = move_and_collide(Vector3.ZERO,true)
	if  col && !col.get_collider() == player:
		_collide()
	if Time.get_ticks_msec()> timestampInstaniated+lifespan:
		_collide()
	
