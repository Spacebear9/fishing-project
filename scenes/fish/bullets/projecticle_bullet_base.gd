extends ShapeCast3D
class_name BulletOld
var pos
var target: Vector3
var timestampInstaniated:float
var player: Player
var speed = 200
var lifespan = 2500
var vel
var cont
var col: Array
var res:ProjecticleResource

func _init(_res:ProjecticleResource,_pos: Vector3, tar: Vector3, _player:Player):
	var res = _res
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
	
func _ready() -> void:
	while !cont == true:
		pass
	global_position = pos
	timestampInstaniated = Time.get_ticks_msec()
	vel = global_position.move_toward(target,speed)-global_position
	vel = vel.normalized() * speed
	

func _process1(delta1):
	target_position = vel*delta1
	#col = auto.shapecast_to_array(self)
	if  col:
		for i in col:
			if i != player:
				_collide()
				return
	if Time.get_ticks_msec()> timestampInstaniated+lifespan:
		_collide()
	position += vel*delta1
	

func _effect_explode(radius = 10):
	var mesh_inst = MeshInstance3D.new()
	var mesh = SphereMesh.new()
	mesh.radius = radius
	mesh.height = radius * 2
	
	
	
	var sfom = StandardMaterial3D.new()
	sfom.cull_mode = BaseMaterial3D.CULL_DISABLED
	sfom.albedo_color = Color(255,0,0,1)

	mesh_inst.mesh = mesh
	mesh_inst.set_surface_override_material(0,sfom)
	add_child(mesh_inst)
