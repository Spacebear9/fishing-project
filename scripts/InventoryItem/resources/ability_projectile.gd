extends Ability
class_name AbilityProjectile

@export var mesh:Mesh

@export var speed:float

@export var aoe_radius:float
@export var knockback:float
@export var knockback_falloff:Curve

@export var effects:Array[ProjectileEffect]
