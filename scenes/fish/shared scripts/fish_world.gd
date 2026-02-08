extends Node3D
class_name WorldFish

@export var properties: WorldFishRes

func _init(resource:WorldFishRes,_bounds:Vector4,_position) -> void:
	position = _position
	properties = resource


var model: Node3D
var anim: AnimationPlayer
var mesh: MeshInstance3D
var parent: Water
func _ready() -> void:
	model = properties.model.instantiate()
	model.scale = Vector3(properties.scale,properties.scale,properties.scale)
	#very suspect change later
	if model.get_child(0).get_child(0).get_child(0) is MeshInstance3D:
		mesh = model.get_child(0).get_child(0).get_child(0)
		if properties.material:
			mesh.set_surface_override_material(0,properties.material)
	
	for child in model.get_children():
		if child is AnimationPlayer:
			anim = child
	add_child(model)
	anim.play(anim.get_animation_list()[properties.anim_swim])
	parent = get_parent()
	target = position

func _process(_delta: float) -> void:
	swim()


var target: Vector3
var control: Vector3
func swim():
	if position.distance_to(target) < 1:
		target = parent.get_random()
		control = parent.get_random()
	position = position.move_toward(target,0.25)
	var temp = rotation
	look_at(target,Vector3(0,1,0))
	rotation = Vector3(temp.x,rotation.y,temp.z)
