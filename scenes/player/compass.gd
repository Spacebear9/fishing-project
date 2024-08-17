extends Panel

@export var player:Player

#var c1= ColorRect.new()
var t1c = 0
var center = 0.5
var t2c = 0
var t1 = TextureRect.new()
var t2 = TextureRect.new()
var gra = Gradient.new()
var gra2 = Gradient.new()
var tex = GradientTexture1D.new()
var tex2 = GradientTexture1D.new()
func _ready():
	gra.set_color(0,Color.WHITE)
	gra2.set_color(0,Color.RED)
	gra2.set_color(1,Color.RED)
	tex.gradient = gra
	tex2.gradient = gra2
	t1.texture = tex
	t2.texture = tex2
	t2.set_anchors_and_offsets_preset(PRESET_FULL_RECT,Control.PRESET_MODE_MINSIZE,0)
	t1.set_anchors_and_offsets_preset(PRESET_FULL_RECT,Control.PRESET_MODE_MINSIZE,0)
	t1.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	t2.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	add_child(t1)
	#add_child(t2)


func _process(delta):
	t1c = player.lateral_vel.angle()-player.wish_vec.angle()
	if t1c > PI:
		t1c = t1c-(2*PI)
	if t1c < -PI:
		t1c = t1c+(2*PI)
	t1c = 0.5-(t1c/PI)
	if player.input_vec == Vector2.ZERO:
		t1c = 0.5
	t1c = min(max(t1c,-0.1),1.1)
	
	center = move_toward(center,t1c,abs(center - t1c)/6 + 0.001)
	
	if center < 0 || center > 1:
		t1.texture = tex2
	else:
		t1.texture = tex
	

	t1.anchor_left = center - 0.005
	t1.anchor_right = center + 0.005
	if center - 0.005 < 0:
		t1.anchor_right = 0
		#t1.anchor_top = center
		#t1.anchor_bottom = 1-center
	if center + 0.005 > 1:
		t1.anchor_left = 1
		#t1.anchor_top = 1-center
		#t1.anchor_bottom = center
