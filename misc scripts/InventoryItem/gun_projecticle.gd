extends "res://misc scripts/InventoryItem/gun.gd"

@export var projectileresource : ProjectileRes

func _ready():
	super()
func _process(delta):
	super(delta)
	pass
func _fire(launch: Vector3,target: Vector3):
	anim.play("shoot")
	auto.root.add_child(Bullet.new(projectileresource,launch,target))
func get_icon():
	return Inventoryresource.Icon
