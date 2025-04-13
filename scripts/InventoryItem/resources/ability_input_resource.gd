extends Resource
class_name AbilityInputResource

enum input_types{
		repeat_fire,
		cancel_fire,
		hold_fire
	}

@export var input_action: InputEventAction
@export var input_type:input_types
@export var abilities: Array[Ability]
