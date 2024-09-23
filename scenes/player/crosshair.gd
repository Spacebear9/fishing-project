extends CenterContainer

func _on_pause_pause() -> void:
	visible = false
func _on_pause_unpause() -> void:
	visible = true
