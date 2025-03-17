extends ShapeCast3D
class_name Bullet

var res:ProjectileRes
var con:ProjectileCon

func _init(_res:ProjectileRes,_con:ProjectileCon):
	res = _res
	con = _con

func _ready() -> void:
	var mesh = MeshInstance3D
	add_child(mesh)
