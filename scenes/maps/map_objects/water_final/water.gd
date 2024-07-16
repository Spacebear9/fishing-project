@tool
extends MeshInstance3D
class_name Water

@export_range(0,500) var width: float
@export_range(0,500) var height: float
@export_range(0,10) var resolution: float = 5

func _ready():
	if !Engine.is_editor_hint():
		export_to_game()
func _process(delta):
	if Engine.is_editor_hint():
		export_to_game()
		
func export_to_game():
	var meshedit: PlaneMesh = mesh
	meshedit.size = Vector2(width,height)
	meshedit.subdivide_width = roundi(width/resolution)
	meshedit.subdivide_depth = roundi(height/resolution)
	mesh = meshedit
	get_surface_override_material(0).set_shader_parameter("scale1",(width+height))
	get_surface_override_material(0).set_shader_parameter("scale2",(width+height))
