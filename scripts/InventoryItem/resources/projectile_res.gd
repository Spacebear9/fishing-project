extends Resource
#projectile properties to be assigned in the inspector, unique properties of each projectile
class_name ProjectileRes


@export var mesh:Mesh

@export var speed:float

@export var aoe_radius:float
@export var knockback:float
@export var knockback_falloff:Curve

@export var effects:Array[ProjectileEffect]
