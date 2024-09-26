extends InventoryItem
class_name Gun

var camera: Camera3D
var anim: AnimationPlayer
var fire_point
var bullet: PackedScene

var anim_shoot


func _ready():
	_ready1()

func _process(_delta):
	if Input.is_action_just_pressed("primary_action") && !anim.is_playing() && player.moveable:
		_fire(camera.global_position,auto.ScreenPointToRay(camera,1,[player.get_rid()]))
		
#empty code to be used by subclass
func _ready1():
	get_player()
	camera = player.get_node("Camera3D")
	anim = get_node("AnimationPlayer")
	fire_point = get_node("fire_point")
	bullet = load("res://scenes/fish/bullets/bullet01/bullet.tscn")

#run when lmb is pressed
func _fire(launch: Vector3,target: Vector3):
	anim.play(anim_shoot)
	var b: Bullet
	b = bullet.instantiate()
	b._spawn(launch,target,player)
	auto.root.add_child(b)
