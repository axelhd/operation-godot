extends Spatial

export(float) var Speed = 10
export (float) var Damage = 1
export(float) var CollisionBit = 3


var direction : Vector3 = Vector3.ZERO
var Velocity : Vector3 = Vector3.ZERO
var angleDifference

func _ready():
	set_as_toplevel(true)

func _physics_process(delta):
	transform.origin += direction * Speed * delta
	
