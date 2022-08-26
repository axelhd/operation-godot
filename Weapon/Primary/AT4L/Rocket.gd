extends RigidBody

var Explosion = preload("res://models/Effects/Explosion_Basic.tscn")
onready var WaitTimer = $Timer


# Called when the node enters the scene tree for the first time.
func _ready():
	$Jet/Particles.emitting = true
	$Jet/Particles2.emitting = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	print(get_linear_velocity())


func _on_Rocket_body_entered(body):
	print("Hit: ", body)
	var W = get_tree().get_root()
	var P = Explosion.instance()
	P.set_global_transform(get_global_transform())
	W.add_child(P)
	$Rocket.visible = false
	$Jet/Particles.emitting = false
	$Jet/Particles2.emitting = false
	$AudioStreamPlayer3D.playing = false
	self.set_mode(RigidBody.MODE_STATIC)
	WaitTimer.start()


func _on_Timer_timeout():
	self.queue_free()
