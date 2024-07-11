extends StaticBody3D

#change off @export later
var camera: Node3D
var texture
var contain_fish = []



func _ready():
	camera = auto.player.get_node("Camera3D")
	texture = get_node("water_png")
	contain_fish.append(load("res://scenes/fish/bass/bass.tscn"))
	contain_fish.append(load("res://scenes/fish/bass/bass2/bass2.tscn"))
func _physics_process(_delta):
	for collider in get_collision_exceptions():
		remove_collision_exception_with(collider)
	
	while move_and_collide(Vector3.ZERO,true):
		var col = move_and_collide(Vector3.ZERO,true,0.001,false,10)
		add_collision_exception_with(col.get_collider())
		if col.get_collider() is Bobber:
			pass
			#print(col.get_collider())




func _process(_delta):
	if camera.global_position.y < global_position.y :
		texture.show()
	else:
		texture.hide()
