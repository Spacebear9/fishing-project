@tool
extends Resource
class_name MapResource
@export var Map: PackedScene:
	set(new_map):
		Map = new_map
		if Engine.is_editor_hint():
			read_map_properties()
@export_category("Settings")
@export_tool_button("Read Properties from Map") var read_map_properties_button = read_map_properties
@export var UseMapNameFromRootNode: bool = true
@export_category("MapProperties")
@export var MapName: String:
	set(new_name):
		if !UseMapNameFromRootNode:
			MapName = new_name
@export var MapScreenshot: Texture2D
@export var SpawnPointArray: Array[NodePath] = []
func read_map_properties():
	if Map == null:
		return
	var mapInstance = Map.instantiate()
	if UseMapNameFromRootNode:
		MapName = mapInstance.name
	for child in mapInstance.get_children():
		if child is SpawnPoint:
			SpawnPointArray.append(child.get_path())
	var allnodes = recurivelygetchildren(mapInstance)
	for node in allnodes:
		if node is SpawnPoint:
			SpawnPointArray.append(node.get_path())
	notify_property_list_changed()
	
func recurivelygetchildren(node: Node)-> Array[Node]:
	var children = []
	for child in node.get_children():
		children.append(child)
		if child.get_child_count() > 0:
			children += recurivelygetchildren(child)
	return children
