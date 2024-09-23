extends Panel
var paused = false
signal pause
signal unpause

func _ready() -> void:
	_unpause()

func _process(delta: float) -> void:
	if !paused:
		if Input.is_action_just_pressed("ui_cancel"):
			_pause()
	else:
		if Input.is_action_just_pressed("ui_cancel"):
			_unpause()
		
func _pause():
	paused = true
	visible = true
	pause.emit()
	
func _unpause():
	paused = false
	visible = false
	unpause.emit()


func _on_button_pressed() -> void:
	get_tree().quit()


func _on_resume_pressed() -> void:
	_unpause()
