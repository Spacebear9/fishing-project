extends Node

@export var map: PackedScene

func _ready():
	var node = map.instantiate()
	add_child(node)
