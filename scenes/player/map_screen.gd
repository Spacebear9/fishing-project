extends MenuItem

@export var maps : Array[MapResource]

func _ready() -> void:
	var grid = $Panel/VBoxContainer
	for map:MapResource in maps:
		var icon = load("res://scenes/player/map_icon.tscn").instantiate()
		icon = icon as TextureButton
		if map.MapScreenshot:
			icon.texture_normal = map.MapScreenshot
		else:
			icon.texture_normal = load("res://misc textures/unknown.png")
		var label = icon.get_child(0) as Label
		label.text = map.MapName
		grid.add_child(icon)
		icon.connect("pressed",auto.load_map.bind(map))
