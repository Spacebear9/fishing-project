extends Node3D

var inventory = []
var selected = 0

func _ready():
	inventory.append(load("res://scenes/rod.tscn"))
	inventory.append(load("res://scenes/fish/bass.tscn"))
	
	add_child(inventory[selected].instantiate())


func _process(delta):
	if Input.is_action_just_pressed("inventory_next"):
		selected = (selected+1)%inventory.size()
		get_child(0).queue_free()
		add_child(inventory[selected].instantiate())
	if Input.is_action_just_pressed("inventory_previous"):
		selected = (selected-1)%inventory.size()
		get_child(0).queue_free()
		add_child(inventory[selected].instantiate())
