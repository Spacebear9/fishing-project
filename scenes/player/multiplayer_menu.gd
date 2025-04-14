extends MenuItem

@export var host_Label:Label
@export var join_TextEdit:LineEdit

## IMPORTANT get_rid of queue free later, make ui better

func _ready():
	host_Label.text = str(multiplayer.get_unique_id()) 

func on_host_pressed():
	var hosted_ip = auto.host_server()
	host_Label.text = "Hosted at: " + hosted_ip
	queue_free()

func on_join_pressed():
	auto.join_server(join_TextEdit.text)
	queue_free()


func _on_offline_pressed() -> void:
	auto.start_offline()
	queue_free()
