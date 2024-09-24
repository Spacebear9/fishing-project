extends InventoryItem
class_name Gun
var camera: Camera3D
var anim: AnimationPlayer
var fire_point
var bullet: PackedScene
var anim_shoot
func _ready():
	super()
	camera = player.get_node("Camera3D")
	anim = get_node("AnimationPlayer")
	fire_point = get_node("fire_point")
func _process(_delta):
	if Input.is_action_just_pressed("primary_action") && !anim.is_playing() && player.moveable:
		_fire(camera.global_position,auto.ScreenPointToRay(camera,1,[player.get_rid()]))
#run when lmb is pressed
func _fire(launch: Vector3,target: Vector3):
	pass
