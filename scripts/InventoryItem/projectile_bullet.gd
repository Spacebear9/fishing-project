extends RayCast3D
class_name Bullet

var res:ProjectileRes

var target:Vector3
var travel:Vector3

const travel_div = 0.001

var moving = true
var explode_immediatly
func _init(_res:ProjectileRes,_pos:Vector3,_target:Vector3, _explode_immediatly:bool = false):
	res = _res
	target_position = _pos
	target = _target
	explode_immediatly = _explode_immediatly
	
var lifespan: int =0
func _ready() -> void:
	add_exception(auto.get_client_player())
	global_position = target_position
	travel = -(global_position - target).normalized()
	var mesh = MeshInstance3D.new()
	mesh.mesh = res.mesh
	add_child(mesh)
	if explode_immediatly:
		moving = false
		damage(target_position)
		return
	
	
var previewarray: Array
func _process(delta):
	lifespan = 1+lifespan
func _physics_process(delta: float) -> void:
	if moving:
		var collisions = []
		target_position = travel * res.speed
		force_raycast_update()
		if get_collider():
			moving = false
			auto.line(global_position,global_position + target_position,Color.RED,0,false)
			auto.line(global_position+target_position,get_collision_point() ,Color.GREEN,0,false)
			global_position = get_collision_point()
			damage(get_collision_point())
			return
		#else:
			#auto.line(global_position,global_position + target_position,Color.WHITE_SMOKE,0,false)
		position += target_position

func damage(pos:Vector3):
	if explode_immediatly:
		await get_tree().process_frame
	var area = Area3D.new()
	var collision = CollisionShape3D.new()
	var shape = SphereShape3D.new()
	shape.radius=res.aoe_radius
	collision.shape = shape
	auto.add_child(area)
	area.add_child(collision)
	area.collision_mask = 0b00000000_00000000_00000000_00000101
	area.global_position = pos
	await get_tree().physics_frame
	if explode_immediatly:
		await get_tree().physics_frame
	print(collision.global_position)
	print(area.get_overlapping_bodies())
	for collide:PhysicsBody3D in area.get_overlapping_bodies():
		pass
		if collide is Player:
			pass
			#print(res.knockback_falloff.sample(pos.distance_to(collide.position))," , ",pos.distance_to(collide.position))
			var player:Player = collide
			player.knockback += pos.direction_to(player.camera.global_position) * res.knockback_falloff.sample(pos.distance_to(collide.position)) * res.knockback
			print(pos.direction_to(player.position),',',player.knockback)
	#var meshinst = MeshInstance3D.new()
	#var mesh2 = SphereMesh.new()
	#mesh2.height = res.aoe_radius*2
	#mesh2.radius = res.aoe_radius
	#meshinst.mesh = mesh2
	#auto.add_child(meshinst)
	#meshinst.global_position = pos
	#var mat = StandardMaterial3D.new()
	#meshinst.set_surface_override_material(0,mat)
	#mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	#mat.albedo_color = Color(1.0,0.5,0.5,0.2)
	effect_explode(pos)

func effect_explode(pos:Vector3):
	var explode:GPUParticles3D = load("res://scenes/explode_1.tscn").instantiate()
	explode.emitting = true
	auto.add_child(explode)
	explode.global_position = pos
	explode.process_material.emission_sphere_radius = res.aoe_radius
	explode.finished.connect(explode.queue_free)
