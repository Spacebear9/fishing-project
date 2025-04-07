extends Node3D
class_name InventoryItem

var player: Player
@export var Inventoryresource : InventoryResource
var icon : Texture2D

#vars brought over from Gun
var camera: Camera3D
var anim: AnimationPlayer
var fire_point

enum action_phases{
		none,
		start,
		mid,
		end
	}


func _ready():
	player = auto.get_current_player()
	
	camera = player.get_node("Camera3D")
	anim = get_node("Mesh/AnimationPlayer")
	if has_node("fire_point"):
		fire_point = get_node("fire_point")

func _process(delta: float) -> void:
	if player.moveable:
		for action in Inventoryresource.actions:
			var phase = action_phases.none
			match action.input_type:
				action.input_types.repeat_fire:
					if !Input.is_action_pressed(action.input_action.action):
						continue
				action.input_types.cancel_fire:
					if !Input.is_action_just_pressed(action.input_action.action):
						continue
				action.input_types.hold_fire:
					if Input.is_action_just_pressed(action.input_action.action):
						phase = action_phases.start
					elif Input.is_action_pressed(action.input_action.action):
						phase = action_phases.mid
					elif Input.is_action_just_released(action.input_action.action):
						phase = action_phases.end
					else:
						continue
					
					
			for ability in action.abilities:
				if ability is AbilityProjectile:
					if (get_parent() as PlayerInventory).weaponid[Inventoryresource] == 0:
						(get_parent() as PlayerInventory).weaponid[Inventoryresource] = Inventoryresource.cooldown
						_fire_projectile(fire_point.global_position,auto.ScreenPointToRay(camera,1,[player.get_rid()]),ability)
				else:
					unknown_ability(ability,phase)
func end_effects():
	pass

func unknown_ability(ability:Ability,phase:int):
	pass


func get_icon():
	return Inventoryresource.Icon

	
func _fire_projectile(launch: Vector3,target: Vector3,res:AbilityProjectile):
	if anim.is_playing():
		anim.stop()
	anim.play("shoot")
	var space_state = get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.new()
	ray_query.exclude = [auto.get_players()[0]]
	ray_query.from = auto.get_players()[0].camera.global_position
	ray_query.to = launch
	var result = space_state.intersect_ray(ray_query)
	var explode_immediatly = (result.size() > 0)
	if explode_immediatly:
		auto.root.add_child(Bullet.new(res, result["position"], target, explode_immediatly))
	else:
		auto.root.add_child(Bullet.new(res, launch, target, explode_immediatly))
