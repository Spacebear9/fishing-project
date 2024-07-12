@tool
extends Node3D
@export var FishToSpawn: Array[PackedScene]
var colisionSpawners: Dictionary
var invalidshapes: bool
# Called when the node enters the scene tree for the first time.
func SpawnFish():
	var totalarea
	var currentarea: float = 0
	var randomselection: float
	var spawnedfish: Node3D
	var curentshape: BoxShape3D
	for ColisionNode in colisionSpawners:
		
		currentarea = colisionSpawners[ColisionNode].get_shape()
		totalarea += (colisionSpawners[ColisionNode].get_shape().get_size().x)*(colisionSpawners[ColisionNode].get_shape().get_size().y)*(colisionSpawners[ColisionNode].get_shape().get_size().z)
	randomselection = randf()
	for ColisionNode in colisionSpawners:
		if randomselection < currentarea + (colisionSpawners[ColisionNode].shape.get_size()/totalarea):
			spawnedfish = FishToSpawn.pick_random().instantiate()
			spawnedfish.reparent(self)
			spawnedfish.position = Vector3(randf_range(ColisionNode.position.x-ColisionNode.shape.get_size().x,ColisionNode.position.x+ColisionNode.shape.get_size().x),randf_range(ColisionNode.position.y-ColisionNode.shape.get_size().y,ColisionNode.position.y+ColisionNode.shape.get_size().y),randf_range(ColisionNode.position.z-ColisionNode.shape.get_size().z,ColisionNode.position.z+ColisionNode.shape.get_size().z))
			return
		else:
			currentarea += totalarea
		printerr("No fish was spawned")
		return
	#Calculate Areas of Each Colision Shape
func _ready():
	for shape in get_children():
		if shape is CollisionShape3D:
			if shape.shape is BoxShape3D:
				colisionSpawners[shape] = shape
			else:
				invalidshapes = true
	if invalidshapes == true and Engine.is_editor_hint() == true:
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
	else:
		if Time.get_ticks_msec()%10==1:
			SpawnFish()
