extends KinematicBody

export var speed = 500

var space_state
var target
var hear = 0
var health = 100

onready var particles = $Particles
onready var BS = $blood_splatter/Particles
onready var blood_splatter = preload("res://BloodSplatter.tscn")

#var rand2 = RandomNumberGenerator.new()

func x():
	var rand = RandomNumberGenerator.new()
	var enemysene = load("res://FPS.tscn")
	
	var spawn_area = 25
		
	for _i in range(0, 10):
		var enemy = enemysene.instance()
		rand.randomize()
		var x = rand.randi_range(-25, 25)
		rand.randomize()
		var z = rand.randi_range(-25, 25)
		enemy.set_position(Vector3(x, 1.2, z))
		add_child(enemy)

func _ready():
	space_state = get_world().direct_space_state
	#rand2.randomize()
	
func _process(delta):
	
	if health <=0:
		
		print("Dead")
		blood_splatter.emit_changed()
		queue_free()
	
	if target:
		#var hear_posibility = rand2.randi_range(0, 100)
		var result = space_state.intersect_ray(global_transform.origin, target.global_transform.origin)
		if result.collider.is_in_group("Player"):
			look_at(target.global_transform.origin, Vector3.UP)
			move_to_target(delta)
		
		elif hear == 1:
			look_at(target.global_transform.origin, Vector3.UP)
			move_to_target(delta)
		
		else:
			target = null


func _on_Area_body_entered(body):
	#print(body.name + "+")
	if body.is_in_group("Player"):
		target = body
		print(body.name + "+p")
		##var hear_posibility = rand2.randi_range(0, 100)
		##if hear_posibility >= 25:
			##hear = 1
			


func _on_Area_body_exited(body):
	#print(body.name + "-")
	if body.is_in_group("Player"):
		target = null
		print(body.name + "-p")
		
func move_to_target(delta):
	
	if health <=0:
		queue_free()
	var direction = (target.global_transform.origin - global_transform.origin).normalized()
	move_and_slide(direction * speed * delta, Vector3.UP)
	
	if health <=0:
		queue_free()


func _on_Explosion_range_body_entered(body):
	if body.is_in_group("Player"):
		body.health -= 25
		particles.emitting = true
		yield(get_tree().create_timer(1.0), "timeout")
		queue_free()
