extends Node



func _ready():
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
		enemy.global_transform.x = x
		add_child(enemy)
