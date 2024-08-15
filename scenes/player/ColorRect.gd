extends ColorRect

@export var player: Player
var center = 0

func _ready():
	#set_anchor(SIDE_TOP,0)
	#set_anchor(SIDE_BOTTOM,1)
	anchor_top = 0
	anchor_bottom = 1

func _process(delta):
	center = -(((player.lateral_vel.angle()+PI)-(player.wish_vec.angle()+PI))/PI)+0.5
	#set_anchor(SIDE_LEFT,center-0.005)
	#set_anchor(SIDE_RIGHT,center+0.005)
	anchor_left = center-0.005
	anchor_right = center+0.005
	print(center)
