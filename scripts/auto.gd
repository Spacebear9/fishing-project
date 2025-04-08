extends Node3D
const gravity = 2
var root

var mapResource:MapResource = load("res://scenes/maps/dm_grove/dm_grove.tres")
var player_TEMP = load("res://scenes/player/player.tscn")
var players_active: Array[Player]
var MapNode: Node3D

func _ready():
	root = get_tree().root
	MapNode = mapResource.MapPackedScene.instantiate()
	add_child(MapNode)
	var player = player_TEMP.instantiate()
	add_child(player)
	players_active.append(player)
	respawn_player(player)	
func _process(_delta):
	pass
		
func line(pos1: Vector3, pos2: Vector3, color = Color.BLACK,time = 1,on_top = true):
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := StandardMaterial3D.new()

	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	if on_top:
		mesh_instance.layers = 0b00000000_00000000_00000000_00000010
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(pos1)
	immediate_mesh.surface_add_vertex(pos2)
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = color
	
	get_tree().get_root().add_child(mesh_instance)
	if time == 0:
		return
	elif time == 1:
		await get_tree().physics_frame
	mesh_instance.queue_free()
func curve(pos1: Vector3, pos2: Vector3,pos3: Vector3, detail: float, color = Color.BLACK):
	for i in Vector3(0,1,(1/detail)):
		line(lerp(lerp(pos1,pos3,i),lerp(pos3,pos2,i),i),lerp(lerp(pos1,pos3,i+(1/detail)),lerp(pos3,pos2,i+(1/detail)),i+(1/detail)),color)
func curve_length(pos1: Vector3, pos2: Vector3,pos3: Vector3, detail: float):
	var sum
	for i in Vector3(0,1,(1/detail)):
		sum = lerp(lerp(pos1,pos3,i),lerp(pos3,pos2,i),i).distance_to(lerp(lerp(pos1,pos3,i+(1/detail)),lerp(pos3,pos2,i+(1/detail)),i+(1/detail)))
	return sum
func pCurve(pos1: Vector3, pos2: Vector3, pos3: Vector3, weight: float):
	return lerp(lerp(pos1,pos3,weight),lerp(pos3,pos2,weight),weight)

func ScreenPointToRay(camera: Camera3D, mask = 0b00000000_00000000_00000000_00000010, exclude = null, return_full = false):
	var spaceState = get_world_3d().direct_space_state
	#var mousePos = Vector2(get_viewport().get_visible_rect().size.x/2,get_viewport().get_visible_rect().size.y/2)
	var rayOrigin = camera.global_position
	#change later this sucks
	var rayEnd = camera.project_ray_normal(Vector2(576,324))*4000
	var rayQuery = PhysicsRayQueryParameters3D.create(rayOrigin,rayEnd)
	rayQuery.collision_mask = mask
	if exclude:
		rayQuery.exclude = exclude
	var rayArray = spaceState.intersect_ray(rayQuery)
	if return_full:
		return rayArray
	if rayArray.has("position"):
		return rayArray["position"]
	return rayEnd

func get_angle(vector: Vector2):
	if vector == Vector2.ZERO:
		return 0
	if vector.y >= 0:
		return atan2(vector.y,vector.x)
	if vector.x >= 0:
		return atan2(vector.y,vector.x) + (PI)
	if vector.x < 0:
		return atan2(vector.y,vector.x) - (PI)
	return 0
	
func recurivelygetchildren(node: Node)-> Array[Node]:
	var children = []
	for child in node.get_children():
		children.append(child)
		if child.get_child_count() > 0:
			children += recurivelygetchildren(child)
	return children
#TEMP REPLACE LATER!!!!
func get_players() -> Array[Player]:
	return players_active
func respawn_player(player_to_spawn:Player):
	var respawn_point_list:Array[SpawnPoint]
	for respawnpointNodePath in mapResource.SpawnPointArray:
		respawn_point_list.append(MapNode.get_node(respawnpointNodePath))
	var spawn_point_of_last_resort:SpawnPoint = respawn_point_list.pick_random()
	while respawn_point_list.size()>0:
		var spawnpointtocheck:SpawnPoint = respawn_point_list.pick_random()
		var can_spawn_player = spawnpointtocheck.TrySpawnPlayer(player_to_spawn)
		if can_spawn_player:
			spawn_point_of_last_resort = spawnpointtocheck
			break
		respawn_point_list.erase(spawnpointtocheck)
	if respawn_point_list.size()==0:
		printerr("No valid spawn point, add more to this map")
	player_to_spawn.global_position = spawn_point_of_last_resort.global_position
	player_to_spawn.rotation.y = spawn_point_of_last_resort.rotation.y + PI
	player_to_spawn.velocity = Vector3.ZERO
	player_to_spawn.knockback = Vector3.ZERO
