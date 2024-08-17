@tool
extends Node3D
@export var DebugFishSpawning: bool
@export var FishToSpawn: Array[PackedScene]
@export var spawntime: int = 5000
var colisionSpawners: Dictionary
var invalidshapes: bool
var timestamp = 0
func SpawnFish():
	timestamp = Time.get_ticks_msec()
	var totalarea : float = 0
	var currentarea: float = 0
	var randomselection: float
	var spawnedfish: Node3D
	var curentshape
	for ColisionNode in colisionSpawners:
		currentarea = (colisionSpawners[ColisionNode].get_shape().get_size().x)*(colisionSpawners[ColisionNode].get_shape().get_size().y)*(colisionSpawners[ColisionNode].get_shape().get_size().z)
		totalarea += (colisionSpawners[ColisionNode].get_shape().get_size().x)*(colisionSpawners[ColisionNode].get_shape().get_size().y)*(colisionSpawners[ColisionNode].get_shape().get_size().z)
	randomselection = randf()
	for ColisionNode in colisionSpawners:
		if randomselection < currentarea + ((colisionSpawners[ColisionNode].get_shape().get_size().x)*(colisionSpawners[ColisionNode].get_shape().get_size().y)*(colisionSpawners[ColisionNode].get_shape().get_size().z)/totalarea):
			spawnedfish = FishToSpawn.pick_random().instantiate()
			add_child(spawnedfish)
			spawnedfish.position = Vector3(randf_range(ColisionNode.position.x-(ColisionNode.shape.get_size().x/2),ColisionNode.position.x+(ColisionNode.shape.get_size().x/2)),randf_range(ColisionNode.position.y-(ColisionNode.shape.get_size().y/2),ColisionNode.position.y+(ColisionNode.shape.get_size().y/2)),randf_range(ColisionNode.position.z-(ColisionNode.shape.get_size().z/2),ColisionNode.position.z+(ColisionNode.shape.get_size().z/2)))
			return
		else:
			currentarea += totalarea
		printerr("No fish were spawned")
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
		if Time.get_ticks_msec() > timestamp + spawntime && DebugFishSpawning == true:
			SpawnFish()
