extends Panel

@export var player:Player

var c1= Label.new()
var c1c = 0

func _ready():
	add_child(c1)
	c1.set_anchors_preset(Control.PRESET_FULL_RECT)
	c1.text = "a"
	c1.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	#c1c.anchor_top = 0.0
	#c1c.anchor_bottom = 1.0


func _process(delta):
	c1c = -(((player.lateral_vel.angle()+PI)-(player.wish_vec.angle()+PI))/PI)+0.5
	#c1c.anchor_left = c1c - 0.005
	#c1c.anchor_right = c1c + 0.005

