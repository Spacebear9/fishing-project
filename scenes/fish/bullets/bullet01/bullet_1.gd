extends Bullet

@export var smallR: float
@export var bigR: float
@export var mesh: MeshInstance3D
const meshExp = 10
var collide = false
var lifespan_exp = 1000
var timestamp = 0

func _ready():
	speed = 100
	if shape.is_class("SphereShape3D"):
		shape.radius = smallR
	mesh.scale = Vector3(smallR,smallR,smallR)
	_ready1()
func _physics_process(delta):
	if !collide:
		_process1(delta)
	if collide:
		
		if Time.get_ticks_msec() > timestamp + lifespan_exp:
			queue_free()

func _collide():
	timestamp = Time.get_ticks_msec()
	collide = true
	
	print("--Call 1--" + str(Time.get_ticks_msec()))
	for i in col.size():
		print(col[i].name)
	
	var sp = SphereShape3D.new()
	sp.radius = 1000
	set_shape(sp)
	mesh.scale = Vector3(bigR,bigR,bigR)
	
	var sfom = StandardMaterial3D.new()
	sfom.cull_mode = BaseMaterial3D.CULL_DISABLED
	sfom.albedo_color = Color(255,0,0,1)
	mesh.set_surface_override_material(0,sfom)
	
	#collision_mask = 0b00000100
	
	var col =  auto.shapecast_to_array(self)
	print("--Call 2--" + str(Time.get_ticks_msec()))
	for i in col.size():
		print(col[i].name)
	
