extends InventoryItem
class_name Gun

@export var gun_res:GunRes
var camera: Camera3D
var anim: AnimationPlayer
var fire_point
var anim_shoot
func _ready():
	super()
	camera = player.get_node("Camera3D")
	anim = get_node("Mesh/AnimationPlayer")
	fire_point = get_node("fire_point")
func _process(_delta):
	pass
func primary_function():
	if (get_parent() as PlayerInventory).weaponid[Inventoryresource] == 0:
		(get_parent() as PlayerInventory).weaponid[Inventoryresource] = Inventoryresource.cooldown
		_fire(fire_point.global_position,auto.ScreenPointToRay(camera,1,[player.get_rid()]))
		_fire.rpc_id(1,[fire_point.global_position,auto.ScreenPointToRay(camera,1,[player.get_rid()])])
	else:
		return
	#if not anim.is_playing():
		#_fire(fire_point.global_position,auto.ScreenPointToRay(camera,1,[player.get_rid()]))
#run when lmb is pressed
@rpc("any_peer","call_remote")
func _fire(launch: Vector3,target: Vector3):
	pass
