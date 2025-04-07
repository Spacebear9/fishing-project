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
@export var SpawnPointPackedScene: PackedScene = load("uid://bdlnkqvpjo6dr")
@export var UseMapNameFromRootNode: bool = true
@export_category("MapProperties")
var _map_name: String
@export var MapName: String:
	get:
		return _map_name
	set(new_name):
		if !UseMapNameFromRootNode:
			_internal_set_map_name(new_name)
@export var MapScreenshot: Texture2D
@export var SpawnPointArray: Array[NodePath] = []
func _internal_set_map_name(new_name: String):
	_map_name = new_name
	notify_property_list_changed()

func read_map_properties():
	if Map == null:
		return
	SpawnPointArray.clear()
	var mapInstance: SceneState = Map.get_state()
	var found_root_name = false 
	for i in range(mapInstance.get_node_count()):
		#print(mapInstance.get_node_instance(i))
		#print(mapInstance.get_node_name(i))
		if UseMapNameFromRootNode and !found_root_name and mapInstance.get_node_path(i) == NodePath("."):
			_internal_set_map_name(mapInstance.get_node_name(i))
			found_root_name = true
		if mapInstance.get_node_instance(i)==SpawnPointPackedScene:
			SpawnPointArray.append(mapInstance.get_node_path(i))
			#for j in range(mapInstance.get_node_instance(i).get_state().get_node_count()):
			#	print(mapInstance.get_node_instance(i).get_state().GET_NODE)
			#if mapInstance.get_node_instance(i).get_state():
			#`	SpawnPointArray.append(mapInstance.get_node_path(i))
	notify_property_list_changed()
	
func recurivelygetchildren(node: Node)-> Array[Node]:
	var children: Array[Node] = []
	for child in node.get_children():
		children.append(child)
		if child.get_child_count() > 0:
			children += recurivelygetchildren(child)
	return children
