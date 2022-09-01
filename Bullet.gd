extends RigidBody

onready var Timer = $Timer

var shoot = false

const DAMAGE = 50
const SPEED = 1000

func _ready():
	set_as_toplevel(true)
	Timer.wait_time = 5
	Timer.start()
	
	
func _physics_process(delta):
	if shoot:
		apply_impulse(transform.basis.z, -transform.basis.z * SPEED)
	if Input.is_action_just_pressed("DestroyBullets"):
		queue_free()


func _on_Area_body_entered(body):
	if body.is_in_group("Enemy") or body.is_in_group("Player"):
		body.health -= DAMAGE
		queue_free()


func _on_Timer_timeout():
	queue_free()
