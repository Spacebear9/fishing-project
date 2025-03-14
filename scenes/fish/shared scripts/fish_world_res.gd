extends Resource
class_name WorldFishRes

#!!! mesh should always be in .glb format
@export var model: PackedScene

#animations are stored as indices relative to their order under AnimationPlayer
@export var anim_swim: int
@export var anim_bind: int

@export var material: Material
@export var scale:float = 1
