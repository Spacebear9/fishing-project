extends ShapeCast3D
class_name Bullet

var res:ProjectileRes

var target:Vector3
var travel:Vector3

var moving = true

func _init(_res:ProjectileRes,_pos:Vector3,_target:Vector3):
	res = _res
	target_position = _pos
	target = _target
	
var lifespan: int =0
func _ready() -> void:
	global_position = target_position
	travel = -(global_position - target).normalized()
	shape = res.shape
	var mesh = MeshInstance3D.new()
	mesh.mesh = res.mesh
	add_child(mesh)
var previewarray: Array
func _process(delta):
	lifespan = 1+lifespan
func _physics_process(delta: float) -> void:
	if moving:
		target_position = travel * res.speed
		var collisions = []
		for i in get_collision_count():
			collisions.append(get_collider(i))
		if collisions != [] && lifespan>2:
			for c in collisions:
				pass
			global_position = get_collision_point(0)
			moving = false
		else:
			global_position += target_position	
func effect_explode(pos:Vector3):
	var mesh_inst = MeshInstance3D.new()
	
