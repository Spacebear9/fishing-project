extends InventoryItem
#@export var RodResoruce: InventoryResource

##This whole script sucks ass

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

enum states{
		resting,
		swinging,
		floating,
		reeling,
		ending
	}
func _ready():
	super()
	bobber = load("res://scenes/bobber/bobber.tscn").instantiate()
	add_child(bobber)
	bobber.scale*=2
	cast_point = get_node("Mesh/cast_point")

func _process(_delta):
	if active:
		match bState:
				states.resting:
					bobber.global_position = cast_point.global_position - Vector3(0,4,0)
					#auto.line(bobber.global_position,cast_point.global_position)
					if input && not anim.is_playing():
						anim.play("swing")
						
						bStart = cast_point.global_position
						bEnd = RaycastHelper.raycast_from_camera(camera)
						bControl = lerp(bStart,Vector3(bEnd.x,bStart.y,bEnd.z),.5)
						bControl. y += abs(bStart.y-bEnd.y)
						bTravel = 0
						
						bState = states.swinging
				states.swinging:
					bTravel += bSpeed/auto.curve_length(bStart,bEnd,bControl,10)
					bobber.global_position = auto.pCurve(bStart,bEnd,bControl,bTravel)
					auto.curve(bobber.global_position,cast_point.global_position,Vector3(cast_point.global_position.x,bobber.global_position.y,cast_point.global_position.z),10)
					if bTravel >= 1:
						input = false
						bState = states.floating
				states.floating:
					auto.curve(bobber.global_position,cast_point.global_position,Vector3(cast_point.global_position.x,bobber.global_position.y,cast_point.global_position.z),10)
					bobber.global_position = bEnd
					if input:
						anim.play("reel")
						bState = states.reeling
				states.reeling:
					auto.curve(bobber.global_position,cast_point.global_position,Vector3(cast_point.global_position.x,bobber.global_position.y,cast_point.global_position.z),10)
					bobber.global_position = bobber.global_position.move_toward(cast_point.global_position,2)
					if bobber.global_position.distance_to(cast_point.global_position) < 0.1:
						anim.play("return")
						input = false
						bState = states.resting

		#auto.line(bStart,bControl,Color.DARK_GREEN)
		#auto.line(bEnd,bControl,Color.DARK_RED)
		#auto.line(bStart,bEnd,Color.YELLOW)
		auto.curve(bStart,bEnd,bControl,10.0)

var input = false
func primary_function():
	input = true
