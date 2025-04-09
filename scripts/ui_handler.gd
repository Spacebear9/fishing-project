extends CanvasLayer
class_name UiHandler

@export var first_active:MenuItem
var active:Control
var all_children:Array[Control]
var hierarchy: Array[MenuItem]


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") && active.escapable:
		escape()

func _ready() -> void:
	for child in get_children():
		if child is Control:
			all_children.append(child)
			child.hide()
	switch(first_active)

func switch(switch_to:MenuItem):
	if active:
		active.hide()
	active = switch_to
	active.show()
	hierarchy.append(active)

func escape():
	if hierarchy.size() > 1 && active == hierarchy[hierarchy.size()-1]:
		hierarchy.remove_at(hierarchy.size()-1)
		active.hide()
		active = hierarchy[hierarchy.size()-1]
		active.show()
