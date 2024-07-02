extends Node3D
const gravity = 1
var player

func _ready():
	player = get_node("/root").get_child(1).get_node("player")


func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
		
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

func ScreenPointToRay(camera: Camera3D):
	var spaceState = get_world_3d().direct_space_state
	var mousePos = get_viewport().get_mouse_position()
	var rayOrigin = camera.project_ray_origin(mousePos)
	var rayEnd = camera.project_ray_normal(mousePos)*4000
	var rayQuery = PhysicsRayQueryParameters3D.create(rayOrigin,rayEnd)
	rayQuery.collision_mask = 0b00000000_00000000_00000000_00000010
	var rayArray = spaceState.intersect_ray(rayQuery)
	if rayArray.has("position"):
		return rayArray["position"]
	return rayEnd
