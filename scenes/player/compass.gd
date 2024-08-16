extends Panel

@export var player:Player

#var c1= ColorRect.new()
var c1c = 0
var t1 = TextureRect.new()

func _ready():
	t1.texture = GradientTexture2D.new()
	t1.set_anchors_and_offsets_preset(PRESET_FULL_RECT,Control.PRESET_MODE_MINSIZE,0)
	t1.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	add_child(t1)
	#add_child(c1)
	#c1.set_anchors_preset(Control.PRESET_FULL_RECT)
	#c1.text = "a"
	#c1.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	#c1.anchor_top = 0.0
	#c1.anchor_bottom = 1.0
	#c1.size = Vector2(10,100)


func _process(delta):
	pass
	c1c = -(((player.lateral_vel.angle()+PI)-(player.wish_vec.angle()+PI))/PI)+0.5
	print(rad_to_deg(player.lateral_vel.angle())+180)
	t1.anchor_left = c1c - 0.005
	t1.anchor_right = c1c + 0.005
	#c1.anchor_left = 0
	#c1.anchor_right = 1
	
