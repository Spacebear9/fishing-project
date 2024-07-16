@tool
extends MeshInstance3D
class_name Water

@export_range(0,500) var width: float
@export_range(0,500) var height: float
@export_range(0,10) var resolution: float = 5

func _ready():
	pass
func _process(delta):
	if Engine.is_editor_hint():
		var meshedit: PlaneMesh = mesh
		meshedit.size = Vector2(width,height)
		meshedit.subdivide_width = roundi(width/resolution)
		meshedit.subdivide_depth = roundi(height/resolution)
		meshedit.material.set("shader_parameter/scale1",(width*height)/2)
		meshedit.material.set("shader_parameter/scale2",(width*height)/2)
		mesh = meshedit
