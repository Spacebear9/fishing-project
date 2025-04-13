@tool
extends Node3D
class_name Water

@export var water_plane: Vector2
@export var water_roughness: float

@export var spawn_bounds:Vector4

var plane_child: MeshInstance3D
var shape: Shape3D
func _ready() -> void:
	plane_child = MeshInstance3D.new()
	var mesh = PlaneMesh.new()
	mesh.subdivide_depth = 100
	mesh.subdivide_width = 100
	plane_child.mesh = mesh
	
	shape = BoxShape3D.new()
	shape.size = Vector3(spawn_bounds.x,spawn_bounds.y,spawn_bounds.z)
	
	if Engine.is_editor_hint():
		ed_mesh = BoxMesh.new()
		ed_mesh_inst = MeshInstance3D.new()
		ed_mesh_inst.mesh = ed_mesh
		var tmp_mat = StandardMaterial3D.new()
		tmp_mat.albedo_color = Color(.9,.55,.35,0.5)
		tmp_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		ed_mesh_inst.set_surface_override_material(0,tmp_mat)
		add_child(ed_mesh_inst)
		edit_update()
	update()
	add_child(plane_child)
	if not Engine.is_editor_hint():
		var timer = Timer.new()
		timer.connect("timeout",spawn_fish)
		add_child(timer)
		timer.start(0.01)


func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		update()
		edit_update()
	else:
		check_under()

@export var spawnable_fish:Array[WorldFishRes]
var spawned_fish:Array[WorldFish]
func spawn_fish():
	if can_spawn():
		if spawnable_fish.size() > 0:
			var spawning = WorldFish.new(spawnable_fish[randi_range(0,spawnable_fish.size())-1],spawn_bounds,get_random())
			add_child(spawning)
			spawned_fish.append(spawning)

func can_spawn():
	if spawned_fish.size() < 3:
		return true
	else:
		return false

func get_random() -> Vector3:
	return Vector3(randf_range(-spawn_bounds.x,spawn_bounds.x)/2,randf_range(-spawn_bounds.y,spawn_bounds.y)/2-spawn_bounds.w,randf_range(-spawn_bounds.z,spawn_bounds.z)/2)

func check_under():
	for player in auto.get_players():
		if player.global_position.x < plane_child.global_position.x + water_plane.x && player.global_position.x > plane_child.global_position.x - water_plane.x && player.global_position.z < plane_child.global_position.z + water_plane.y && player.global_position.z > plane_child.global_position.z - water_plane.y && player.camera.global_position.y < plane_child.global_position.y:
			if not player.in_water:
				player.enter_water()
		else:
			if player.in_water:
				player.exit_water()

func update():
	plane_child.scale = Vector3(water_plane.x,1.0,water_plane.y)
	var mat1:ShaderMaterial = load("res://scenes/maps/map_objects/water final v2/water_first.tres").duplicate(true)
	mat1.set_shader_parameter("height_scale",water_roughness)
	mat1.next_pass.set_shader_parameter("height_scale",water_roughness)
	plane_child.set_surface_override_material(0,mat1)


var ed_mesh: BoxMesh
var ed_mesh_inst: MeshInstance3D
func edit_update():
	ed_mesh.size = Vector3(spawn_bounds.x,spawn_bounds.y,spawn_bounds.z)
	ed_mesh_inst.mesh = ed_mesh
	ed_mesh_inst.position.y = -spawn_bounds.w
