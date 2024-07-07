extends MeshInstance3D
class_name Fish

var camera: Camera3D
var anim: AnimationPlayer
var fire_point
var bullet: PackedScene


func _ready():
	print("1")
	#ready code applicible to every weapon in the game
	#do not overwrite via polymorphism instead write to _ready2()
	camera = auto.player.get_node("Camera3D")
	anim = get_node("AnimationPlayer")
	fire_point = get_node("fire_point")
	bullet = load("res://scenes/fish/bullets/bullet01/bullet.tscn")
	print("2")
	#_ready2() call includes custom subclass code after _ready() 
	_ready2()

func _process(_delta):
	#begin cast if able
	if Input.is_action_just_pressed("primary_action") && !anim.is_playing():
		_fire(fire_point.global_position,auto.ScreenPointToRay(camera))
		
#empty code to be used by subclass
func _ready2():
	pass

#run when lmb is pressed
func _fire(launch: Vector3,target: Vector3):
	var b: Bullet
	b = bullet.instantiate()
	b._spawn(launch,target)
	auto.root.add_child(b)
