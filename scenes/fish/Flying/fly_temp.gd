extends InventoryItem

enum states{
	ground,
	air,
	flying
	}
var time = 0
var state = states.air

func _process(delta: float) -> void:
	time =-inventory.weapon_data[Inventoryresource][1] + 2 
	super(delta)
	print(time)
	
	if player.is_on_floor() && state != states.ground:
		state = states.ground
	elif state == states.ground:
		state = states.air
	
	match state:
		states.ground:
			time = Inventoryresource.actions[1].abilities[0].time
		states.flying:
			
			time -= delta
			if time <= 0:
				_unhover()
	inventory.weapon_data[Inventoryresource][1] = -time + 2

func unknown_ability(ability:Ability,phase:int):
	if phase == action_phases.start:
		_hover(ability)
	if phase == action_phases.end:
		_unhover()

func end_effects():
	_unhover()


func _hover(res:AbilityHover):
	state = states.flying
	player.gravity = res.gravity
	player.terminal_vel = res.terminal_vel
	player.speed_accel_air = res.air_accel
func _unhover():
	state = states.air
	player.gravity = player.s_gravity
	player.terminal_vel = player.s_terminal_vel
	player.speed_accel_air = player.s_speed_accel_air
