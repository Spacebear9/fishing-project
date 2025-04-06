extends Node3D
class_name PlayerInventory
@export var player: Player
signal inv_changed

#var inventory: Array[InventoryItem] = []
var inventory = []
func _ready():
	inventory.append(load("res://scenes/rod/rod.tscn"))
	inventory.append(load("res://scenes/fish/bass/bass.tscn"))
	switch_inventory(0)

func switch_next():
	switch_inventory((selected+1+inventory.size())%inventory.size())
func switch_prev():
	switch_inventory((selected-1+inventory.size())%inventory.size())

var selected = -1
func switch_inventory(switch_to:int):
	if switch_to == selected:
		return
	if get_child(0):
			get_child(0).queue_free()
	if inventory.size() > switch_to:
		var add = inventory[switch_to].instantiate()
		add_child(add)
		player.held_item = add
		selected = switch_to
		inv_changed.emit()
