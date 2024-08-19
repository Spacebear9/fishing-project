extends InventoryItem

var camera: Camera3D
var anim: AnimationPlayer
var bobber: StaticBody3D
var cast_point

var s = 0
var e = 0
var stop = false

var bTravel = 0
var bSpeed = .1
var bState = 0
var bStart = Vector3.ZERO
var bEnd = Vector3.ZERO
var bControl = Vector3.ZERO


func _ready():
	get_player()
	camera = player.get_node("Camera3D")
	anim = get_node("AnimationPlayer")
	
	bobber = load("res://scenes/bobber/bobber.tscn").instantiate()
	add_child(bobber)
	bobber.scale*=10

	
	#
	cast_point = get_node("cast_point")

func _process(_delta):
		#begin cast if able
		###!!!!!!! change if inputjustpressed to a method of all inventory items to simplify
	if Input.is_action_just_pressed("primary_action") && !anim.is_playing() && bState == 0 && player.moveable:
		anim.play("swing")
		s = Time.get_ticks_msec()
		bTravel = 0
		bState = 1
		stop = false
	
	if bState == 1 && bTravel <= 1 && !anim.is_playing():
		bStart = cast_point.global_position
		bEnd = auto.ScreenPointToRay(camera)
		bControl = lerp(bStart,Vector3(bEnd.x,bStart.y,bEnd.z),.5)
		bControl. y += abs(bStart.y-bEnd.y)
		print(snapped(auto.curve_length(bStart,bEnd,bControl,10),.01))
		bState = 2
	
	if bState == 2 && bTravel <= 1 && !anim.is_playing():
		bTravel += bSpeed/auto.curve_length(bStart,bEnd,bControl,10)
	
	if bState == 2 && bTravel >= 1 && !stop:
		stop = true
		e = Time.get_ticks_msec()
		print("in " + str(e-s))
		
	if bState == 2 && bTravel >= 1 && !anim.is_playing() && Input.is_action_just_pressed("primary_action"):
		anim.play("reel")
		bState = 3
		
	if bState == 3 && bobber.global_position.distance_to(cast_point.global_position) >= 0.00001:
		bobber.global_position = bobber.global_position.move_toward(cast_point.global_position,2)
	if bState == 3 && bobber.global_position.distance_to(cast_point.global_position) <= 0.00001:
		anim.play("return")
		bState = 0
	
	
	
	if bState < 2:
		bobber.global_position = Vector3(cast_point.global_position.x,cast_point.global_position.y-3,cast_point.global_position.z)
		auto.line(bobber.global_position,cast_point.global_position)
	elif bState == 2:
		bobber.global_position = auto.pCurve(bStart,bEnd,bControl,bTravel)
		auto.curve(bobber.global_position,cast_point.global_position,Vector3(cast_point.global_position.x,bobber.global_position.y,cast_point.global_position.z),10)
	elif bState == 3:
		auto.curve(bobber.global_position,cast_point.global_position,Vector3(cast_point.global_position.x,bobber.global_position.y,cast_point.global_position.z),10)
	#auto.line(bStart,bControl,Color.DARK_GREEN)
	#auto.line(bEnd,bControl,Color.DARK_RED)
	#auto.line(bStart,bEnd,Color.YELLOW)
	#auto.curve(bStart,bEnd,bControl,10.0)
