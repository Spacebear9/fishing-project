extends Resource
class_name InventoryResource 
@export var Name : String
@export var packed_scene:PackedScene
@export var Icon: Texture2D

#what is the maximum value of a cooldown
@export var cooldown:float
#which cooldown should be displayed on the hotbar
@export var cooldown_display = 0

@export var actions:Array[AbilityInputResource]
