extends HBoxContainer

var inv_get: PlayerInventory
func _ready():
	inv_get = auto.player.get_node("Camera3D").get_node("inventory")
	_set_hotbar()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _set_hotbar():
	for child in get_children():
		child.queue_free()
	for slot:int in inv_get.inventory.size():
		print(inv_get.selected)
		var label = Label.new()
		label.text = str(slot+1)
		label.label_settings = LabelSettings.new()
		if slot == inv_get.selected:
			label.label_settings.font_color = Color.RED
		add_child(label)

func _on_inventory_inv_changed():
	_set_hotbar()
