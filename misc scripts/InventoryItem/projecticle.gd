extends "res://misc scripts/InventoryItem/gun.gd"

@export var projecticleresource : ProjecticleResource
# Called when the node enters the scene tree for the first time.
func _ready():
	super()
	bullet = projecticleresource.Bullet

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super(delta)
	pass
func _fire(launch: Vector3,target: Vector3):
	anim.play("shoot")
	var b: Bullet
	b = bullet.instantiate()
	b._spawn(launch,target,player)
	auto.root.add_child(b)
func set_icon():
	icon = projecticleresource.icon
