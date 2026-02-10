extends RayCast3D
class_name Bullet

var res:AbilityProjectile

var target:Vector3
var travel:Vector3

const travel_div = 0.001

var moving = true
var explode_immediatly
func _init(_res:AbilityProjectile,_pos:Vector3,_target:Vector3, _explode_immediatly:bool = false):
	res = _res
	target_position = _pos
	target = _target
	explode_immediatly = _explode_immediatly
	
var lifespan: int =0
func _ready() -> void:
	add_exception(auto.players_active[0])
	global_position = target_position
	travel = -(global_position - target).normalized()
	var mesh = MeshInstance3D.new()
	mesh.mesh = res.mesh
	add_child(mesh)
	if explode_immediatly:
		moving = false
		damage(target_position)
		return
	get_tree().create_timer(10).timeout.connect(queue_free)
	
var previewarray: Array
func _process(_delta):
	lifespan = 1+lifespan
func _physics_process(_delta: float) -> void:
	if moving:
		target_position = travel * res.speed
		force_raycast_update()
		if get_collider():
			moving = false
			add_child(LineHelper.create_line(global_position,global_position+target_position,null,Color.RED))
			global_position = get_collision_point()
			damage(get_collision_point())
			return
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
	for collide:PhysicsBody3D in area.get_overlapping_bodies():
		if collide is Player:
			var player:Player = collide
			player.knockback += pos.direction_to(player.camera.global_position) * res.knockback_falloff.sample(pos.distance_to(collide.position)) * res.knockback
	effect_explode(pos)

func effect_explode(pos:Vector3):
	var explosive_projectile_mesh = get_child(0)
	explosive_projectile_mesh.visible = false 
	
	var explode:GPUParticles3D = load("res://scenes/explode_1.tscn").instantiate()
	explode.emitting = true
	auto.add_child(explode)
	explode.global_position = pos
	explode.process_material.emission_sphere_radius = res.aoe_radius
	explode.finished.connect(queue_free)
