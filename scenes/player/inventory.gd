extends Node3D
class_name PlayerInventory
@export var player: Player
signal inv_changed


@export var weaponid:Dictionary[InventoryResource,float] = {} 

var inventory: Array

func _ready():
	inventory.append(load("res://scenes/rod/rod.tscn"))
	inventory.append(load("res://scenes/fish/Flying/fly_temp.tscn"))
	inventory.append(load("res://scenes/fish/bass/bass.tscn"))
	
	switch_inventory(0)

func _process(delta: float) -> void:
	for fishie in weaponid:
		weaponid[fishie] -= delta
		weaponid[fishie] = clamp(weaponid[fishie],0,INF)
		

func switch_next():
	switch_inventory((selected+1+inventory.size())%inventory.size())
func switch_prev():
	switch_inventory((selected-1+inventory.size())%inventory.size())

var selected = -1
func switch_inventory(switch_to:int):
	if switch_to == selected:
		return
	if get_children().size() > 0:
			var child = get_child(0) as InventoryItem
			child.end_effects()
			child.queue_free()
	if inventory.size() > switch_to:
		var add = inventory[switch_to].instantiate()
		add_child(add)
		player.held_item = add
		selected = switch_to
		inv_changed.emit()
