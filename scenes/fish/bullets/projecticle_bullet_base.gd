extends ShapeCast3D
class_name Bullet
var pos
var target: Vector3
var timestampInstaniated:float
var player: Player
var speed = 200
var lifespan = 2500
var vel
var cont
var col: Array
func _spawn(_pos: Vector3, tar: Vector3, _player:Player):
	pos = _pos
	target = tar
	player = _player
	cont = true
func _physics_process(delta: float) -> void:
	_process1(delta)
		
func _collide():
	print("--Call 1--")
	for i in col.size():
		print(col[i].name)
	queue_free()
func _ready1():
	while !cont == true:
		pass
	global_position = pos
	timestampInstaniated = Time.get_ticks_msec()
	vel = global_position.move_toward(target,speed)-global_position
	vel = vel.normalized() * speed

func _process1(delta1):
	target_position = vel*delta1
	col = auto.shapecast_to_array(self)	
	if  col:
		for i in col:
			if i != player:
				_collide()
				return
	if Time.get_ticks_msec()> timestampInstaniated+lifespan:
		_collide()
	position += vel*delta1
	
