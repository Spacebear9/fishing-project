extends Control
class_name MenuItem

var menu:UIHandler
@export var escapable = true

func _ready() -> void:
	menu = get_parent()
	if menu is not UIHandler:
		auto.unique_error("parent node is not UiHandler, MenuItem should always be a child of UiHandler",self)
