extends Node3D
const gravity = 2
var root

var map = load("res://scenes/maps/clementine eagleston yiik/DM_Clem.tscn")
var player_TEMP = load("res://scenes/player/player.tscn")

func _ready():
	root = get_tree().root
	var node = map.instantiate()
	add_child(node)
	var player = player_TEMP.instantiate()
	add_child(player)
	player.global_position = Vector3(15,10,0)

func _process(_delta):
	pass
		
func line(pos1: Vector3, pos2: Vector3, color = Color.BLACK):
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := StandardMaterial3D.new()

	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	mesh_instance.layers = 0b00000000_00000000_00000000_00000010
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(pos1)
	immediate_mesh.surface_add_vertex(pos2)
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = color
	
	get_tree().get_root().add_child(mesh_instance)
	await get_tree().physics_frame
	mesh_instance.queue_free()
func curve(pos1: Vector3, pos2: Vector3,pos3: Vector3, detail: float, color = Color.BLACK):
	for i in Vector3(0,1,(1/detail)):
		line(lerp(lerp(pos1,pos3,i),lerp(pos3,pos2,i),i),lerp(lerp(pos1,pos3,i+(1/detail)),lerp(pos3,pos2,i+(1/detail)),i+(1/detail)),color)
func curve_length(pos1: Vector3, pos2: Vector3,pos3: Vector3, detail: float):
	var sum
	for i in Vector3(0,1,(1/detail)):
		sum = lerp(lerp(pos1,pos3,i),lerp(pos3,pos2,i),i).distance_to(lerp(lerp(pos1,pos3,i+(1/detail)),lerp(pos3,pos2,i+(1/detail)),i+(1/detail)))
	return sum
	
func pCurve(pos1: Vector3, pos2: Vector3, pos3: Vector3, weight: float):
	return lerp(lerp(pos1,pos3,weight),lerp(pos3,pos2,weight),weight)

func ScreenPointToRay(camera: Camera3D, mask = 0b00000000_00000000_00000000_00000010, exclude = null, return_full = false):
	var spaceState = get_world_3d().direct_space_state
	var mousePos = get_viewport().get_mouse_position()
	var rayOrigin = camera.project_ray_origin(mousePos)
	var rayEnd = camera.project_ray_normal(mousePos)*4000
	var rayQuery = PhysicsRayQueryParameters3D.create(rayOrigin,rayEnd)
	rayQuery.collision_mask = mask
	if exclude:
		rayQuery.exclude = exclude
	var rayArray = spaceState.intersect_ray(rayQuery)
	if return_full:
		return rayArray
	if rayArray.has("position"):
		return rayArray["position"]
	return rayEnd

func get_angle(vector: Vector2):
	if vector == Vector2.ZERO:
		return 0
	if vector.y >= 0:
		return atan2(vector.y,vector.x)
	if vector.x >= 0:
		return atan2(vector.y,vector.x) + (PI)
	if vector.x < 0:
		return atan2(vector.y,vector.x) - (PI)
	return 0
	
func shapecast_to_array(cast:ShapeCast3D) -> Array:
	var array: Array
	for i in cast.get_collision_count():
		array.append(cast.get_collider(i))
	return array
