extends CharacterBody3D
class_name Player

@export var anim: AnimationPlayer
@onready var camera = $Camera3D
@onready var view_cam = $Camera3D/SubViewportContainer/SubViewport/view_cam


#mouse direction
var mouse_dir: Vector2
#look sensitivity (scaler for mouse_dir)
var sense = 6

var jump_buffer = 0

#camera strafe roll strength
var strafe_factor = .07
#jump strength
const jump_strength = 50

var lateral_vel
var input_vec = Vector2.ZERO
var input_rot = 0
var speed_max = 45
var speed_accel_ground = 270
var speed_accel_air = 35
var speed_friction = 120



func _ready():	
	#capture mouse
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(_delta):
	view_cam.global_transform = camera.global_transform


func _physics_process(delta):
	lateral_vel = Vector2(velocity.x,velocity.z)
	
	friction(delta)
	input_vec = Input.get_vector("movement_strafe_left","movement_strafe_right","movement_forward","movement_backward")
	lateral_vel = accelerate(input_vec,lateral_vel,delta)
	#TOFIX: change friction to be before accelerate
	

	
	#get jump input
	if Input.is_action_just_pressed("movement_jump"):
		jump_buffer = 5
	if jump_buffer > 0:
		jump_buffer -= 1
		if is_on_floor():
			velocity.y += jump_strength+(lateral_vel.length()/10)
	
	
	
	#camera roll when strafing
	camera.rotation.z = move_toward(camera.rotation.z,sign(-input_vec.x)*strafe_factor,.02)
	
	#all player velocity checks
	if !is_on_floor():
		velocity.y -= auto.gravity
	
	velocity = Vector3(lateral_vel.x,velocity.y,lateral_vel.y)
	
	move_and_slide()





func _unhandled_input(event: InputEvent):
	if event is InputEventMouseMotion:
		#get mouse direction
		mouse_dir = event.relative * 0.001
		#rotate yaw
		rotation.y -= mouse_dir.x * sense
		#rotate pitch
		camera.rotation.x -= mouse_dir.y * sense

func accelerate(direction_vec,current_vel,delta):
	var wish_vec
	if direction_vec != Vector2(0,0):
		input_rot = atan2(direction_vec.y,direction_vec.x)
		wish_vec = Vector2(cos(-global_rotation.y+input_rot),sin(-global_rotation.y+input_rot))
	else:
		wish_vec = Vector2.ZERO
	var speed_scale = wish_vec.dot(current_vel)
	var speed_gain = speed_max - speed_scale
	#speed_gain = max(min(speed_gain,speed_accel*delta),-speed_accel*delta)
	if is_on_floor():
		speed_gain = max(min(speed_gain,speed_accel_ground*delta),0)
	else:
		speed_gain = max(min(speed_gain,speed_accel_air*delta),0)
	auto.line(global_position,global_position+Vector3(wish_vec.x,0,wish_vec.y))
	return current_vel+(wish_vec*speed_gain)

func friction(delta):
	if is_on_floor():
		lateral_vel = lateral_vel.move_toward(Vector2.ZERO,speed_friction*delta)

