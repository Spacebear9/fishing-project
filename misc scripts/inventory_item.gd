extends MeshInstance3D
class_name InventoryItem

@export var icon: Texture
var player: Player

func get_player():
	player = get_parent().get_parent().get_parent()
