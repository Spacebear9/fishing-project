extends HBoxContainer
class_name Hotbar

var icons: Dictionary[InventoryResource,TextureRect]
var inv_get: PlayerInventory
@export var player: Player
func _ready():
	while !inv_get:
		inv_get = player.get_node("Camera3D").get_node("inventory")
	_set_hotbar()


func set_percent(percent:float,res:InventoryResource):
	icons[res].material.set_shader_parameter("percent",percent)

func _set_hotbar():
	icons.clear()
	for child in get_children():
		child.queue_free()
	inv_get = player.get_node("Camera3D").get_node("inventory")
	for slot:int in inv_get.inventory.size():
		var label = Label.new()
		label.text = str(slot+1)
		label.label_settings = LabelSettings.new()
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		if slot == inv_get.selected:
			label.label_settings.font_color = Color.RED
		var inventoryitem:InventoryItem = inv_get.inventory[slot];
		var icon = inventoryitem.get_icon()
		var rect = TextureRect.new()
		icons[inventoryitem.Inventoryresource] = rect
		rect.material = load("uid://dq02w0vu74cxg").duplicate()
		rect.texture = icon
		rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		rect.custom_minimum_size = Vector2(35,35)
		var vbox = VBoxContainer.new()
		add_child(vbox)
		vbox.add_child(label)
		vbox.add_child(rect)

func _on_inventory_inv_changed():
	_set_hotbar()
