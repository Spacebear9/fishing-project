@tool
extends Node3D
class_name SpawnPoint
@export var spawn_point_CollisionShape: Shape3D
var shapecast: ShapeCast3D
func _ready():
	shapecast = get_node("ShapeCast3D")
	shapecast.shape = spawn_point_CollisionShape
	if Engine.is_editor_hint():
		visible = true
	else:
		visible = false
func TrySpawnPlayer(player: Player):
	shapecast.enabled = true
	shapecast.force_shapecast_update()
	if shapecast.is_colliding():
		var Collision_Array = shapecast.collision_result
		for i in Collision_Array:
			if i.collider is Player:
				return false
	shapecast.enabled = false
	player.global_position = global_position
	return true 
