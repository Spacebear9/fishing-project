extends Gun

@export var projectileresource : ProjectileRes

func _ready():
	super()
func _process(delta):
	super(delta)
	pass
@rpc("any_peer","call_remote")
func _fire(launch: Vector3, target: Vector3):
	anim.play("shoot")
	var space_state = get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.new()
	ray_query.exclude = [player]
	ray_query.from = player.camera.global_position
	ray_query.to = launch
	var result = space_state.intersect_ray(ray_query)
	var explode_immediatly = (result.size() > 0)
	if explode_immediatly:
		#Will be fun to merge with the new action system
		auto.local_MultiplayerSpawner.spawn(["bullet", projectileresource, result["position"], target, explode_immediatly])
		#auto.local_MultiplayerSpawner.add_child(Bullet.new(projectileresource, result["position"], target, explode_immediatly))
	else:
		auto.local_MultiplayerSpawner.spawn(["bullet", projectileresource, launch, target, explode_immediatly])
		#auto.local_MultiplayerSpawner.add_child(Bullet.new(projectileresource, launch, target, explode_immediatly))
func get_icon():
	return Inventoryresource.Icon
