extends Node

@export var map: PackedScene
@export var player_TEMP: PackedScene

func _ready():
	var node = map.instantiate()
	add_child(node)
	var player = player_TEMP.instantiate()
	add_child(player)
	player.global_position = Vector3(0,10,0)
