extends KinematicBody

var speed = 7
var acceleration = 50
var gravity = 20
var jump = 10
var ads = 0
var health = 100

var mv = 0

var damage = 3
var pistol_damage = 75
export var melee_damage = 30
var spread = 15
var sniper_spread = 0.5
var current_weapon = 0

var mouse_sensitivity = 0.1

var direction = Vector3()
var velocity = Vector3()
var fall = Vector3() 
onready var knife = $Head/Camera/MelleWeapon/Knife
onready var head = $Head
onready var aimcast = $Head/Camera/RayCast
onready var muzzle = $Head/Camera/Hand/Gun3/Muzzle
onready var bullet = preload("res://Bullet.tscn")
onready var blood_splatter = preload("res://BloodSplatter.tscn")
onready var gun = $Head/Camera/Hand/Gun1
onready var gun2 = $Head/Camera/Hand/Gun2
onready var gun3 = $Head/Camera/Hand/Gun3
#onready var camera = $Head/Camera/
onready var ray_container = $Head/Camera/RayContainer
onready var hitbox = $Head/Camera/Hitbox
onready var melee_anim = $AnimationPlayer
onready var anim = $AnimationPlayer2
#THIS NEEDS TO BE REMOVED!!!!!!##################################
func fire_pistol():
	if Input.is_action_just_pressed("fire"):
		var ray = aimcast
		if ray != null:
			ray.cast_to.x = rand_range(sniper_spread, -sniper_spread)
			ray.cast_to.y = rand_range(sniper_spread, -sniper_spread)
			if ray.is_colliding():
				print("Hit Something")
				if ray.get_collider().is_in_group("Enemy"):
					ray.get_collider().health -= pistol_damage
					
					print("Hit Enemy")
############################################################
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	randomize()
	
func melee():
	if Input.is_action_just_pressed("fire"):
		if not melee_anim.is_playing():
			melee_anim.play("Attack")
			melee_anim.queue("Return")
		
		if melee_anim.current_animation == "Attack":
			for body in hitbox.get_overlapping_bodies():
				body.health -= melee_damage

func fire_not_shotgun():
	if Input.is_action_just_pressed("fire") and aimcast != null and bullet != null:
		if aimcast.is_colliding():
			var b = bullet.instance()
			muzzle.add_child(b)
			b.look_at(aimcast.get_collision_point(), Vector3.UP)
			b.shoot = true 

func fire_shotgun():
	if Input.is_action_just_pressed("fire") and ray_container != null:
		if mv == 0:
			for r in ray_container.get_children():
				if r != null:
					r.cast_to.x = rand_range(spread, -spread)
					r.cast_to.y = rand_range(spread, -spread)
					if r.is_colliding():
						print("Hit Something")
						if r.get_collider().is_in_group("Enemy"):
							r.get_collider().health -= damage
							print("Hit Enemy")
					
				
func _input(event):
	if mv == 0:
		if event is InputEventMouseMotion and head != null:
			rotate_y(deg2rad(-event.relative.x * mouse_sensitivity)) 
			head.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity)) 
			head.rotation.x = clamp(head.rotation.x, deg2rad(-90), deg2rad(90))
	if event.is_action_pressed("fire2"):
		ads_scoped1()
	if event.is_action_released("fire2"):
		ads_scoped2()
	
		

func hw():
	if FirstPerson.current_weapon == 1:
		if gun and gun2 and knife and gun3 != null:
			gun.visible = true
			gun2.visible = false
			gun3.visible = false
			knife.visible = false
			
	if FirstPerson.current_weapon == 0:
		if gun and gun2 and knife and gun3 != null:
			gun.visible = false
			gun3.visible = false
			gun2.visible = false
			knife.visible = false
	
	elif FirstPerson.current_weapon == 2:
		if gun and gun2 and knife and gun3 != null:
			gun.visible = false
			gun3.visible = false
			gun2.visible = true
			knife.visible = false
	
	elif FirstPerson.current_weapon == 3:
		if gun and gun2 and knife and gun3 != null:
			gun.visible = false
			gun3.visible = false
			gun2.visible = false
			knife.visible = true
	
	elif FirstPerson.current_weapon == 4:
		if gun and gun2 and knife and gun3 != null:
			gun.visible = false
			gun3.visible = true
			gun2.visible = false
			knife.visible = false

func weapon_select():
	
	if Input.is_action_just_pressed("Weapon1"):
		current_weapon = 1
		print("1")
	
	elif Input.is_action_just_pressed("Weapon2"):
		current_weapon = 2
		print("2")
			
	elif Input.is_action_just_pressed("weapon4"):
		current_weapon = 4
		print("4")
		
	#elif Input.is_action_just_pressed("melee"):
		#current_weapon = 3
		#print("3")
		
	if FirstPerson.current_weapon == 1:
		if gun and gun2 and knife != null:
			gun.visible = true
			gun2.visible = false
			knife.visible = false
			
	if FirstPerson.current_weapon == 0:
		if gun and gun2 and knife != null:
			gun.visible = false
			gun2.visible = false
			knife.visible = false
	
	elif FirstPerson.current_weapon == 2:
		if gun and gun2 and knife != null:
			gun.visible = false
			gun2.visible = true
			knife.visible = false
	
	elif FirstPerson.current_weapon == 3:
		if gun and gun2 and knife != null:
			gun.visible = false
			gun2.visible = false
			knife.visible = true
		
	elif FirstPerson.current_weapon == 4:
		if gun and gun2 and knife != null:
			gun.visible = false
			gun2.visible = false
			knife.visible = true

func ads_scoped1():
	if anim != null and FirstPerson.current_weapon == 4:
		gun3.visible = false
		anim.play("ADS")
		
func ads_scoped2():
	if anim != null and FirstPerson.current_weapon == 4:
		anim.play_backwards("ADS")
		

func _physics_process(delta):
	
	weapon_select()
	
	hw()
	
	if health <= 0:
		print("YouAreDead")
		queue_free()
	
	direction = Vector3()
	#weapon_select()
	
	#guncam.global_transform = camera.global_transform
	if FirstPerson.current_weapon == 1:
		fire_shotgun()

		
	elif FirstPerson.current_weapon == 2:
		fire_pistol()
	
	elif current_weapon == 3:
		pass
		#melee()
	elif FirstPerson.current_weapon == 4:
		fire_not_shotgun()

	
	
	
	
	
	if Input.is_action_just_pressed(("ui_cancel")):
		if mv == 0:
			mv = 1
			print("v")
			print(mv)
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		elif mv == 1:
			mv = 0
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			print(mv)
			print("iv")
	


	if not is_on_floor():
		fall.y -= gravity * delta
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		fall.y = jump
		
	
	if Input.is_action_pressed("move_forward"):
	
		direction -= transform.basis.z
	
	elif Input.is_action_pressed("move_backward"):
		
		direction += transform.basis.z
		
	if Input.is_action_pressed("move_left"):
		
		direction -= transform.basis.x			
		
	elif Input.is_action_pressed("move_right"):
		
		direction += transform.basis.x
			
		
	direction = direction.normalized()
	velocity = velocity.linear_interpolate(direction * speed, acceleration * delta) 
	velocity = move_and_slide(velocity, Vector3.UP) 
	move_and_slide(fall, Vector3.UP)
