extends Gun

@export var projectileresource : ProjectileRes

func _ready():
	super()
func _process(delta):
	super(delta)
	pass
func _fire(launch: Vector3, target: Vector3):
	anim.play("shoot")
	var space_state = get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.new()
	ray_query.exclude = [auto.get_players()[0]]
	ray_query.from = auto.get_players()[0].camera.global_position
	ray_query.to = launch
	var result = space_state.intersect_ray(ray_query)
	var explode_immediatly = (result.size() > 0)
	if explode_immediatly:
		auto.root.add_child(Bullet.new(projectileresource, result["position"], target, explode_immediatly))
	else:
		auto.root.add_child(Bullet.new(projectileresource, launch, target, explode_immediatly))
func get_icon():
	return Inventoryresource.Icon
