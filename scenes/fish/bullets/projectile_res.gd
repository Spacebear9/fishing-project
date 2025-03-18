extends Resource
#projectile properties to be assigned in the inspector, unique properties of each projectile
class_name ProjectileRes

@export var mesh:Mesh
@export var shape:Shape3D

@export var speed:float

@export var effects:Array[ProjectileEffect]
