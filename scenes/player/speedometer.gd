extends Label
var player: Player

func _ready():
	player = auto.player

func _process(delta):
	text = str(snapped(player.lateral_vel.length(),0.01)) + " u/s"
