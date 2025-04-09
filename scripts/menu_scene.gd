extends Control
class_name MenuItem

var menu:UiHandler
@export var escapable = true

func _ready() -> void:
	menu = get_parent()
	if menu is not UiHandler:
		auto.unique_error("parent node is not UiHandler, MenuItem should always be a child of UiHandler",self)
	_start()

func _process(delta: float) -> void:
	if visible:
		_script(delta)

func _start() -> void:
	pass

func _script(_delta:float) -> void:
	pass
