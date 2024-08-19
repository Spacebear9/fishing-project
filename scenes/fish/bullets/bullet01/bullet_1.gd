extends Bullet

@export var smallR: float
@export var bigR: float
@export var mesh: MeshInstance3D
@export var shape: CollisionShape3D
const meshExp = 10
var collide = false
var lifespan_exp = 1000
var timestamp = 0

func _ready():
	speed = 100
	if shape.shape.is_class("SphereShape3D"):
		shape.shape.radius = smallR
	mesh.scale = Vector3(smallR,smallR,smallR)
	_ready1()
func _process(delta):
	if !collide:
		_process1(delta)
	if collide:
		
		if Time.get_ticks_msec() > timestamp + lifespan_exp:
			queue_free()

func _collide():
	collide = true
	timestamp = Time.get_ticks_msec()
	
	shape.shape.radius = bigR
	mesh.scale = Vector3(bigR,bigR,bigR)
	
	var sfom = StandardMaterial3D.new()
	sfom.albedo_color = Color(255,0,0,1)
	mesh.set_surface_override_material(0,sfom)
	
	collision_mask = 0b00000100
	
	var col = move_and_collide(Vector3.ZERO,true)
	print(col)
	
