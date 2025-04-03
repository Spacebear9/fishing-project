extends AnimatableBody3D
class_name Bullet

var res:ProjectileRes

var target:Vector3
var travel:Vector3
var target_position:Vector3

var moving = true

func _init(_res:ProjectileRes,_pos:Vector3,_target:Vector3):
	res = _res
	target_position = _pos
	target = _target
	
var lifespan: int =0
func _ready() -> void:
	add_collision_exception_with(auto.get_players()[0])
	global_position = target_position
	travel = -(target_position - target).normalized()
	var mesh = MeshInstance3D.new()
	mesh.mesh = res.mesh
	add_child(mesh)
	

var previewarray: Array
func _process(delta):
	lifespan = 1+lifespan
func _physics_process(delta: float) -> void:
	if moving:
		#var collisionObject = []
		var collision 
		collision = move_and_collide(travel * res.speed * delta , false)
		#collisionObject = get_colliding_bodies()
		if collision != null:
			print(collision)
			moving = false
			damage(global_position)
			return
		else:
			auto.line(global_position,global_position + target_position,Color.WHITE_SMOKE,0,false)

func damage(pos:Vector3):
	var area = Area3D.new()
	var collision = CollisionShape3D.new()
	var shape = SphereShape3D.new()
	shape.radius=res.aoe_radius
	collision.shape = shape
	add_child(area)
	area.add_child(collision)
	area.collision_mask = 0b00000000_00000000_00000000_00000101
	area.global_position = pos
	await get_tree().physics_frame
	for collide:PhysicsBody3D in area.get_overlapping_bodies():
		if collide is Player:
			#print(res.knockback_falloff.sample(pos.distance_to(collide.position))," , ",pos.distance_to(collide.position))
			var player:Player = collide
			player.knockback += pos.direction_to(player.position) * res.knockback_falloff.sample(pos.distance_to(collide.position)) * res.knockback
			print(pos.direction_to(player.position),',',player.knockback)
			
	
	#var meshinst = MeshInstance3D.new()
	#var mesh2 = SphereMesh.new()
	#mesh2.height = res.aoe_radius*2
	#mesh2.radius = res.aoe_radius
	#meshinst.mesh = mesh2
	#meshinst.global_position = pos
	#var mat = StandardMaterial3D.new()
	#meshinst.set_surface_override_material(0,mat)
	#mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	#mat.albedo_color = Color(1.0,0.5,0.5,0.2)
	#auto.add_child(meshinst)
	
	
	effect_explode(pos)

func effect_explode(pos:Vector3):
	var explode:GPUParticles3D = load("res://scenes/explode_1.tscn").instantiate()
	explode.emitting = true
	auto.add_child(explode)
	explode.global_position = pos
	explode.process_material.emission_sphere_radius = res.aoe_radius
	explode.finished.connect(explode.queue_free)
