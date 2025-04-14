extends CharacterBody3D
class_name Player

@export var anim: AnimationPlayer
@onready var inventory = $Camera3D/inventory
@onready var camera:Camera3D = $Camera3D
@onready var view_cam = $Camera3D/SubViewportContainer/SubViewport/view_cam

var held_item: InventoryItem

var moveable = true

var peer_id

#mouse direction
var mouse_dir: Vector2
#look sensitivity (scaler for mouse_dir)
var sense = 6

var jump_buffer = 0

#camera strafe roll strength
var strafe_factor = .07
#jump strength
const jump_strength = 30

var lateral_vel
var input_vec = Vector2.ZERO
var wish_vec = 0
var input_rot = 0
var speed_max = 50
var speed_accel_ground = 425
var speed_accel_air = 35
var speed_friction = 165

var knockback = Vector3.ZERO

func _enter_tree():
	set_multiplayer_authority(int(name),true)

func _ready():	
	if !is_multiplayer_authority():
		var local_mesh:MeshInstance3D = get_node("Mesh")
		local_mesh.layers = 1000
		return
	#capture mouse
	camera.current=true
	#view_cam.current =true
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(_delta):
	if !is_multiplayer_authority(): return
	view_cam.global_transform = camera.global_transform


func _physics_process(delta):
	if !is_multiplayer_authority(): return
	lateral_vel = Vector2(velocity.x,velocity.z)
	friction(delta)
	
	if moveable:
		#get jump input
		if Input.is_action_pressed("movement_jump"):
			jump_buffer = 7
		if jump_buffer > 0:
			jump_buffer -= 1
			if is_on_floor():
				velocity.y += jump_strength+(lateral_vel.length()/10)
		
		input_vec = Input.get_vector("movement_strafe_left","movement_strafe_right","movement_forward","movement_backward")
		#camera roll when strafing
		camera.rotation.z = move_toward(camera.rotation.z,sign(-input_vec.x)*strafe_factor,.02)
	
	lateral_vel = accelerate(input_vec,lateral_vel,delta)
	
	
	#all player velocity checks
	if !is_on_floor():
		if Input.is_action_pressed("crouch"):
			velocity.y -= auto.gravity*5
		else:
			velocity.y -= auto.gravity
	
	velocity = Vector3(lateral_vel.x,velocity.y,lateral_vel.y)
	velocity += knockback
	knockback = Vector3.ZERO
	
	move_and_slide()



func _input(event: InputEvent) -> void:
	if !is_multiplayer_authority(): return
	if moveable:
		if event.is_action_pressed("primary_action"):
			held_item.primary_function()
		#!action_released() is the only thing that works with scroll wheel, find a better solution later 
		if event.is_action_released("inventory_next"):
			inventory.switch_next()
		if event.is_action_released("inventory_previous"):
			inventory.switch_prev()
		for i in range(1,5):
			if event.is_action_pressed("inventory_"+str(i)):
				inventory.switch_inventory(i-1)

func _unhandled_input(event: InputEvent):
	if !is_multiplayer_authority(): return
	if event is InputEventMouseMotion && moveable:
		#get mouse direction
		mouse_dir = event.relative * 0.001
		#rotate yaw
		rotation.y -= mouse_dir.x * sense
		#rotate pitch
		camera.rotation.x -= mouse_dir.y * sense
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)

func accelerate(direction_vec,current_vel,delta):
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
		

@export var water_rect:ColorRect
@export var use_water_effects = true
var in_water = false
func enter_water():
	in_water = true
	if use_water_effects:
		water_rect.visible = true
func exit_water():
	in_water = false
	if use_water_effects:
		water_rect.visible = false

func _on_pause_pause() -> void:
	if !is_multiplayer_authority(): return
	moveable = false
	input_vec = Vector2.ZERO
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
func _on_pause_unpause() -> void:
	if !is_multiplayer_authority(): return
	moveable = true
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_button_pressed() -> void:
	if !is_multiplayer_authority(): return
	auto.respawn_player(self)
