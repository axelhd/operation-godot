extends MeshInstance

onready var head = $Head
onready var aimcast = $Head/Camera/RayCast
onready var muzzle = $Head/Camera/Hand/Gun/Muzzle
onready var bullet = preload("res://Bullet.tscn")
var spread = 0.5
var damage = 75



func _ready():
	pass

func fire_pistol():
	if Input.is_action_just_pressed("fire"):
		var ray = aimcast
		ray.cast_to.x = rand_range(spread, -spread)
		ray.cast_to.y = rand_range(spread, -spread)
		if ray.is_colliding():
			print("Hit Something")
			if ray.get_collider().is_in_group("Enemy"):
				ray.get_collider().health -= damage
				print("Hit Enemy")
