extends RigidBody

var shoot = false

const DAMAGE = 50
const SPEED = 1000

func _ready():
	set_as_toplevel(true)
	
func _physics_process(delta):
	if Input.is_action_just_pressed("fire") and FirstPerson.current_weapon == 4:
		apply_impulse(transform.basis.z, -transform.basis.z * SPEED)


func _on_Area_body_entered(body):
	if body.is_in_group("Enemy"):
		body.health -= DAMAGE
		queue_free()
	else:
		queue_free()
