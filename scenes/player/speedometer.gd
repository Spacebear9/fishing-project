extends Label
@export var player: Player

func _process(delta):
	text = str(snapped(player.lateral_vel.length()* (320/45),0.01)) + " u/s"
