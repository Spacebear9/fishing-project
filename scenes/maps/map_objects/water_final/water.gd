@tool
extends MeshInstance3D
class_name Water

@export_range(0,500) var width: int = 100
@export_range(0,500) var height: int = 100
@export_range(0,10) var resolution: int = 5

@export var DebugFishSpawning: bool
@export var FishToSpawn: Array[PackedScene]
@export var spawntime: int = 1000
var colisionSpawners: Dictionary
var invalidshapes: bool
var timestamp = 0

func _ready():
	mesh = PlaneMesh.new()
	if !Engine.is_editor_hint():
		export_to_game()
func _process(delta):
	if Engine.is_editor_hint():
		export_to_game()
func export_to_game():
	mesh.size = Vector2(width,height)
	mesh.subdivide_width = roundi(width/resolution)
	mesh.subdivide_depth = roundi(height/resolution)
	mat_set(get_surface_override_material(0))

func mat_set(mat:ShaderMaterial):
	mat.set_shader_parameter("planeWidth",width)
	mat.set_shader_parameter("planeHeight",height)
	if mat.next_pass:
		mat_set(mat.next_pass)

func SpawnFish():
	timestamp = Time.get_ticks_msec()
	var totalarea : float = 0
	var currentarea: float = 0
	var randomselection: float
	var spawnedfish: Node3D
	var curentshape
	for ColisionNode in colisionSpawners:
		curentshape = colisionSpawners[ColisionNode].get_shape().get_size().x
		totalarea += (colisionSpawners[ColisionNode].get_shape().get_size().x)*(colisionSpawners[ColisionNode].get_shape().get_size().y)*(colisionSpawners[ColisionNode].get_shape().get_size().z)
	randomselection = randf()
	for ColisionNode in colisionSpawners:
		if randomselection < currentarea + ((colisionSpawners[ColisionNode].get_shape().get_size().x)*(colisionSpawners[ColisionNode].get_shape().get_size().y)*(colisionSpawners[ColisionNode].get_shape().get_size().z)/totalarea):
			spawnedfish = FishToSpawn.pick_random().instantiate()
			add_child(spawnedfish)
			spawnedfish.position = Vector3(randf_range(ColisionNode.position.x-ColisionNode.shape.get_size().x,ColisionNode.position.x+ColisionNode.shape.get_size().x),randf_range(ColisionNode.position.y-ColisionNode.shape.get_size().y,ColisionNode.position.y+ColisionNode.shape.get_size().y),randf_range(ColisionNode.position.z-ColisionNode.shape.get_size().z,ColisionNode.position.z+ColisionNode.shape.get_size().z))
			return
		else:
			currentarea += totalarea
		printerr("No fish were spawned")
		return
	#Calculate Areas of Each Colision Shape
