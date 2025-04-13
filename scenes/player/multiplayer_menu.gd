extends MenuItem

@export var host_Label:Label
@export var join_TextEdit:LineEdit

func _ready():
	host_Label.text = str(multiplayer.get_unique_id()) 

func on_host_pressed():
	var hosted_ip = auto.host_server()
	host_Label.text = "Hosted at: " + hosted_ip

func on_join_pressed():
	auto.join_server(join_TextEdit.text)
	
