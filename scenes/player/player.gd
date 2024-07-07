extends CharacterBody3D
@export var anim: AnimationPlayer
@onready var camera = $Camera3D
@onready var view_cam = $Camera3D/SubViewportContainer/SubViewport/view_cam

#mouse direction
var mouse_dir: Vector2
#look sensitivity (scaler for mouse_dir)
var sense = 6

#movement direction (y should always be zero)
var move_dir: Vector3
#base movement speed
var move_speed = 20
#rate of acceleration
var move_accel = 1
#camera strafe roll strength
var strafe_factor = .07
#y velocity (GET RID OF)
var ys

func _ready():	
	#capture mouse
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(_delta):
	view_cam.global_transform = camera.global_transform


func _physics_process(_delta):
	

	
	#V3 move_dir (x,*,z) set to normal of movement input
	move_dir = Vector3(Input.get_vector("movement_strafe_left","movement_strafe_right","movement_forward","movement_backward").x,0,Input.get_vector("movement_strafe_left","movement_strafe_right","movement_forward","movement_backward").y)
	
	#get jump input
	if Input.is_action_just_pressed("movement_jump") && is_on_floor():
		velocity.y += 30
	
	#camera roll when strafing
	camera.rotation.z = move_toward(camera.rotation.z,sign(-move_dir.x)*strafe_factor,.02)
	
	#all player velocity checks
	if !is_on_floor():
		velocity.y -= auto.gravity

	ys = velocity.y
	velocity.y = 0
	velocity = velocity.move_toward(global_transform.basis*move_dir*move_speed,3)
	velocity.y = ys


	
	move_and_slide()





func _unhandled_input(event: InputEvent):
	if event is InputEventMouseMotion:
		#get mouse direction
		mouse_dir = event.relative * 0.001
		#rotate yaw
		rotation.y -= mouse_dir.x * sense
		#rotate pitch
		camera.rotation.x -= mouse_dir.y * sense


func ScreenPointToRay():
	var spaceState = get_world_3d().direct_space_state
	var mousePos = get_viewport().get_mouse_position()
	var rayOrigin = camera.project_ray_origin(mousePos)
	var rayEnd = camera.project_ray_normal(mousePos)*4000
	var rayQuery = PhysicsRayQueryParameters3D.create(rayOrigin,rayEnd)
	rayQuery.collision_mask = 2
	var rayArray = spaceState.intersect_ray(rayQuery)
	if rayArray.has("position"):
		return rayArray["position"]
	return rayEnd
