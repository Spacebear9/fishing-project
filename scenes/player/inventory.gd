extends Node3D
class_name PlayerInventory

var inventory = []
var selected = 0
var current
signal inv_changed

func _ready():
	inventory.append(load("res://scenes/rod/rod.tscn"))
	inventory.append(load("res://scenes/fish/bass/bass.tscn"))
	inventory.append(load("res://scenes/fish/bass/bass2/bass2.tscn"))
	
	add_child(inventory[selected].instantiate())


func _process(_delta):
	if Input.is_action_just_pressed("inventory_next"):
		selected = (selected+1)%inventory.size()
		switch_inventory(selected)
	if Input.is_action_just_pressed("inventory_previous"):
		selected = (selected-1)%inventory.size()
		if selected == -1:
			selected = inventory.size()-1
		switch_inventory(selected)
	for i in range(1,5):
		if Input.is_action_just_pressed("inventory_"+str(i)) && i <= inventory.size():
			selected = i-1
			switch_inventory(i-1)
			
func switch_inventory(slot = 0):
		for child in get_children():
			child.queue_free()
		current = inventory[slot].instantiate()
		add_child(current)
		inv_changed.emit()
