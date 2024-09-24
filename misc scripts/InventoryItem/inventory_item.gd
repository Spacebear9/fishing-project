extends MeshInstance3D
class_name InventoryItem

var player: Player
@export var Inventoryresource : InventoryResource
var icon : Texture2D
func _ready():
	get_player()
	set_icon()
func get_player():
	player = get_parent().get_parent().get_parent()
func set_icon():
	icon = Inventoryresource.icon
