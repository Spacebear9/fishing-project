extends Node3D

const gravity = 2
var root:Node

var mapResource:MapResource = load("res://scenes/maps/dm_grove/dm_grove.tres")
var player_TEMP = load("res://scenes/player/player.tscn")
var players_active: Array[Player]
var MapNode: Node

func _ready():
	root = get_tree().root
	load_map(mapResource)

#temp will need to change with multiplayer
func load_map(map:MapResource):
	unload_all()
	MapNode = map.MapPackedScene.instantiate()
	add_child(MapNode)
	var player = player_TEMP.instantiate()
	players_active.append(player)
	add_child(player)
	respawn_player(player)

func unload_all():
	for c in get_children():
		c.queue_free()
	for n in root.get_children():
		if n != self:
			n.queue_free()
	players_active.clear()

###Should move curve to be LineHelper.create_curve()
func curve(pos1: Vector3, pos2: Vector3,pos3: Vector3, detail: float, color = Color.BLACK):
	for i in Vector3(0,1,(1/detail)):
		var line_node = LineHelper.create_line(lerp(lerp(pos1,pos3,i),lerp(pos3,pos2,i),i),
		lerp(lerp(pos1,pos3,i+(1/detail)),lerp(pos3,pos2,i+(1/detail)),i+(1/detail)),
		get_tree().process_frame,color)
		add_child(line_node)

func curve_length(pos1: Vector3, pos2: Vector3,pos3: Vector3, detail: float):
	var sum
	for i in Vector3(0,1,(1/detail)):
		sum = lerp(lerp(pos1,pos3,i),lerp(pos3,pos2,i),i).distance_to(lerp(lerp(pos1,pos3,i+(1/detail)),lerp(pos3,pos2,i+(1/detail)),i+(1/detail)))
	return sum
func pCurve(pos1: Vector3, pos2: Vector3, pos3: Vector3, weight: float):
	return lerp(lerp(pos1,pos3,weight),lerp(pos3,pos2,weight),weight)

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

func get_current_player() -> Player:
	return players_active[0]

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
