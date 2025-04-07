extends Node3D
class_name SpawnPoint
@export var SpawnPointColisionShape: Shape3D
var shapecast: ShapeCast3D
func _ready():
	shapecast = get_node("ShapeCast3D")
	shapecast.shape = SpawnPointColisionShape
func TrySpawnPlayer(player: Player):
	shapecast.enabled = true
	shapecast.force_raycast_update()
	if shapecast.is_colliding():
		var Collision_Array = shapecast.collision_result
		for i in Collision_Array:
			if i.node is Player:
				return false
	shapecast.enabled = false
	player.global_position = global_position
	return true 
