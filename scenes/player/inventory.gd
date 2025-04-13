extends Node3D
class_name PlayerInventory
@export var player: Player
signal inv_changed


#@export var weapon_data:Dictionary[InventoryResource,Array] = {} 

var inventory: Array[InventoryItem]

func _ready():
	
	add_inventory(load("res://scenes/rod/rod.tscn").instantiate())
	add_inventory(load("res://scenes/fish/Flying/fly_temp.tscn").instantiate())
	add_inventory(load("res://scenes/fish/bass/bass.tscn").instantiate())
	
	
	switch_inventory(0)

func add_inventory(to_add:InventoryItem):
	inventory.append(to_add)
	add_child(to_add)
	to_add.switch_off()

func switch_next():
	switch_inventory((selected+1+inventory.size())%inventory.size())
func switch_prev():
	switch_inventory((selected-1+inventory.size())%inventory.size())

var selected = -1
func switch_inventory(switch_to:int):
	if switch_to == selected:
		return
	if inventory[selected]:
			inventory[selected].switch_off()
	if inventory.size() > switch_to:
		var add = inventory[switch_to] as InventoryItem
		add.switch_to()
		player.held_item = add
		selected = switch_to
		inv_changed.emit()
