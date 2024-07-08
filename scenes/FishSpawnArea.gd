@tool
extends Node3D
@export var FishToSpawn: Array[Node3D] = [] 
var colisionSpawners: Dictionary
var invalidshapes: bool
# Called when the node enters the scene tree for the first time.
func SpawnFish():
	var totalarea
	var currentarea: float = 0
	for shape in colisionSpawners:
		totalarea += colisionSpawners[shape]
	return
	#Calculate Areas of Each Colision Shape
func _ready():
	for shape in get_children():
		if shape is CollisionShape3D:
			if shape.shape is BoxShape3D:
				colisionSpawners[shape] = shape.shape.get_size()
			else:
				invalidshapes = true
	if invalidshapes == true and Engine.is_editor_hint():
		push_error()
func _get_configuration_warnings():
	var warnings = []
	if invalidshapes == true:
		warnings.append("Fish spawns is not built to handle anything but BoxShape3D, please implement other shapes or use BoxShapes3Ds.")
	return warnings
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Engine.is_editor_hint():
		for shape in get_children():
			if shape is CollisionShape3D:
				if shape.shape is BoxShape3D:
					continue
				else:
					invalidshapes = true
		if invalidshapes == true:
			update_configuration_warnings()
