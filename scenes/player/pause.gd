extends MenuItem
var paused = false
signal pause
signal unpause

@export var map_screen:MenuItem
@export var multiplayer_menu:MenuItem
func _ready() -> void:
	super()
	_unpause()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if !paused:
			_pause()
		else:
			_unpause()
		
func _pause():
	paused = true
	menu.switch(self)
	pause.emit()
	
	
func _unpause():
	paused = false
	menu.escape()
	unpause.emit()

func switch_map():
	menu.switch(map_screen)

func switch_multiplayer():
	menu.switch(multiplayer_menu)
	
func _on_resume_pressed() -> void:
	_unpause()


func _on_exit_pressed() -> void:
	get_tree().quit()
