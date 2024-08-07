extends Node3D
class_name PlayerInventory
signal inv_changed

var inventory = []
var selected = 0

func _ready():
	inventory.append(load("res://scenes/rod/rod.tscn"))
	inventory.append(load("res://scenes/fish/bass/bass.tscn"))
	inventory.append(load("res://scenes/fish/bass/bass.tscn"))
	
	add_child(inventory[selected].instantiate())


func _process(_delta):
	if Input.is_action_just_pressed("inventory_next"):
		selected = (selected+1)%inventory.size()
		_switch_inventory()
	if Input.is_action_just_pressed("inventory_previous"):
		selected = (selected-1+inventory.size())%inventory.size()
		_switch_inventory()
	for i:int in 5:
		if Input.is_action_just_pressed("inventory_"+str(i)):
			if inventory.size() >= i:
				selected = i -1
				_switch_inventory()


func _switch_inventory():
	get_child(0).queue_free()
	add_child(inventory[selected].instantiate())
	inv_changed.emit()
