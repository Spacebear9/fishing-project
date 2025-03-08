@tool
extends Node3D
class_name Water

@export var water_plane: Vector2

var plane_child: MeshInstance3D
func _ready() -> void:
	plane_child = MeshInstance3D.new()
	plane_child.mesh = PlaneMesh.new()
	plane_child.scale = Vector3(water_plane.x,1.0,water_plane.y)
	add_child(plane_child)


func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		editor_update()

func editor_update():
	plane_child.scale = Vector3(water_plane.x,1.0,water_plane.y)
