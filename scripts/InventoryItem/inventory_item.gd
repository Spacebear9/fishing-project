extends Node3D
class_name InventoryItem

var player: Player
@export var Inventoryresource : InventoryResource
var icon : Texture2D
func _ready():
	get_player()
	
func _input(event: InputEvent) -> void:
	for action in Inventoryresource.actions:
		if event.is_action(action.input_action.action):
			pass
			for ability in action.abilities:
				print(type_string(typeof(ability)))
			#match typeof(ability):
	
func get_player():
	player = get_parent().get_parent().get_parent()
func get_icon():
	return Inventoryresource.Icon

func primary_function():
	pass
