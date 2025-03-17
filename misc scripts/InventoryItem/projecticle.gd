extends "res://misc scripts/InventoryItem/gun.gd"

@export var projectileresource : ProjectileRes

func _ready():
	super()
	bullet = projectileresource.Bullet

func _process(delta):
	super(delta)
	pass
func _fire(launch: Vector3,target: Vector3):
	anim.play("shoot")
	
	var condition = ProjectileCon
	
	auto.root.add_child(Bullet.new(projectileresource,launch,target,player))
func get_icon():
	return projectileresource.Icon
