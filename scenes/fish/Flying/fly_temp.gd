extends InventoryItem

enum states{
	ground,
	air,
	flying
	}
var time = 0
var state = states.air

func _ready() -> void:
	super()
	time = Inventoryresource.actions[1].abilities[0].time

func _process(delta: float) -> void:
	super(delta)
	
	if player.is_on_floor() && state != states.ground:
		state = states.ground
	elif state == states.ground:
		state = states.air
	
	match state:
		states.ground:
			time += delta * Inventoryresource.actions[1].abilities[0].recovery_rate
			time = clamp(time,0,Inventoryresource.actions[1].abilities[0].time)
		states.flying:
			
			time -= delta
			if time <= 0:
				_unhover()

func unknown_ability(ability:Ability,phase:int):
	if phase == action_phases.start:
		_hover(ability)
	if phase == action_phases.end:
		_unhover()

func end_effects():
	_unhover()

func write_cooldown():
	player.hotbar.set_percent(time/Inventoryresource.actions[1].abilities[0].time,Inventoryresource)

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
