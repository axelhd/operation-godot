extends KinematicBody

var speed = 7
var acceleration = 50
var gravity = 20
var jump = 10
var ads = 0
var health = 1

var mv = 0

var damage = 3
var rifle_damage = 75
export var melee_damage = 30
var spread = 15
var rifle_spread = 0.5
var current_weapon = 0

var mouse_sensitivity = 0.1

var direction = Vector3()
var velocity = Vector3()
var fall = Vector3() 
onready var knife = $Head/Camera/MelleWeapon/Knife
onready var head = $Head
onready var aimcast = $Head/Camera/RayCast
onready var muzzle = $Head/Camera/Hand/Gun3/Muzzle
onready var muzzle_sg = $Head/Camera/Hand/Gun1/Muzzle
onready var muzzle_ak = $Head/Camera/Hand/gun6/Muzzle
onready var bullet = preload("res://Bullet.tscn")
#onready var blood_splatter = preload("res://BloodSplatter.tscn")
onready var gun = $Head/Camera/Hand/Gun1
onready var gun2 = $Head/Camera/Hand/Gun2
onready var gun3 = $Head/Camera/Hand/Gun3
onready var gun4 = $Head/Camera/Hand/Gun4
#onready var camera = $Head/Camera/
onready var ray_container = $Head/Camera/RayContainer
onready var hitbox = $Head/Camera/Hitbox
onready var melee_anim = $AnimationPlayer
onready var anim = $AnimationPlayer2
onready var gun6 = $Head/Camera/Hand/gun6
onready var t = get_node("Timer")
var ammo = null
func fire_rifle():
	if Input.is_action_just_pressed("fire"):
		var ray = aimcast
		if ray != null:
			ray.cast_to.x = rand_range(rifle_spread, -rifle_spread)
			ray.cast_to.y = rand_range(rifle_spread, -rifle_spread)
			if ray.is_colliding():
				print("Hit Something")
				if ray.get_collider().is_in_group("Enemy"):
					ray.get_collider().health -= rifle_damage
					
					print("Hit Enemy")
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

func fire_scoped_sniper():
	if Input.is_action_just_pressed("fire") and aimcast != null and bullet != null:
		anim.play("semiautofire")
		if aimcast.is_colliding():
			var b = bullet.instance()
			muzzle.add_child(b)
			b.look_at(aimcast.get_collision_point(), Vector3.UP)
			b.shoot = true 

func reload():
		print("No ammo")
		t.set_wait_time(5) # Set Timer's delay to "sec" seconds
		t.start() # Start the Timer counting down
		yield(t, "timeout") # Wait for the timer to wind down
		ammo = 30
		print("ammo 30")
		fire_assault()

func fire_assault():
	if Input.is_action_pressed("fire") and aimcast != null and bullet and muzzle_ak != null and ammo != 0:
		print("x")
		if not anim.is_playing():
			if aimcast.is_colliding():
				var b = bullet.instance()
				muzzle_ak.add_child(b)
				b.look_at(aimcast.get_collision_point(), Vector3.UP)
				b.shoot = true
				
				
		anim.play("assaultfire")
				
	else:
		if anim != null:
			anim.stop()
	if ammo == 0:
		anim.play("reload")
		ammo = 30
		
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

func fire_shotgun_projectile():
	if Input.is_action_just_pressed("fire") and ray_container != null and ammo != 0:
		if mv == 0:
			for r in ray_container.get_children():
				if r != null:
					r.cast_to.x = rand_range(spread, -spread)
					r.cast_to.y = rand_range(spread, -spread)
					if r.is_colliding():
						var bul = bullet.instance()
						muzzle_sg.add_child(bul)
						bul.look_at(r.get_collision_point(), Vector3.UP)
						bul.shoot = true
	elif ammo == 0:
		print("Out of ammo")
		ammo = 2
						

func reddot():
	if anim != null:
		anim.play("reddot")
	
func unreddot():
	if anim != null:
		anim.play_backwards("reddot")

func _input(event):
	if mv == 0:
		if event is InputEventMouseMotion and head != null:
			rotate_y(deg2rad(-event.relative.x * mouse_sensitivity)) 
			head.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity)) 
			head.rotation.x = clamp(head.rotation.x, deg2rad(-90), deg2rad(90))
	if event.is_action_pressed("fire2"):
		#ads_scoped()
		reddot()
	if event.is_action_released("fire2"):
		#ads_unscoped()
		unreddot()



func hw():
	if FirstPerson.current_weapon == 1:
		if gun and gun2 and knife and gun3 and gun4 and gun6 != null:
			gun.visible = true
			gun2.visible = false
			gun4.visible = false
			gun6.visible = false
			gun3.visible = false
			knife.visible = false
			
	if FirstPerson.current_weapon == 0:
		if gun and gun2 and knife and gun3 and gun4 and gun6 != null:
			gun.visible = false
			gun4.visible = false
			gun3.visible = false
			gun6.visible = false
			gun2.visible = false
			knife.visible = false
	
	elif FirstPerson.current_weapon == 2:
		if gun and gun2 and knife and gun3 and gun4 and gun6 != null:
			gun.visible = false
			gun4.visible = false
			gun3.visible = false
			gun6.visible = false
			gun2.visible = true
			knife.visible = false
	
	elif FirstPerson.current_weapon == 3:
		if gun and gun2 and knife and gun3 and gun4 and gun6 != null:
			gun.visible = false
			gun4.visbile = false
			gun3.visible = false
			gun6.visible = false
			gun2.visible = false
			knife.visible = true
	
	elif FirstPerson.current_weapon == 4 and ads == 0:
		if gun and gun2 and knife and gun3 and gun4 and gun6 != null:
			gun.visible = false
			gun3.visible = true
			gun4.visible = false
			gun6.visible = false
			gun2.visible = false
			knife.visible = false
				
	elif FirstPerson.current_weapon == 4 and ads == 1:
		if gun and gun2 and knife and gun3 and gun4 and gun6 != null:
			gun.visible = false
			gun3.visible = false
			gun2.visible = false
			gun6.visible = false
			gun4.visible = false
			knife.visible = false
				
	elif FirstPerson.current_weapon == 5:
		if gun and gun2 and knife and gun3 and gun4 and gun6 != null:
			gun.visible = false
			gun3.visible = false
			gun2.visible = false
			gun4.visible = true
			gun6.visible = false
			
			knife.visible = false

	elif FirstPerson.current_weapon == 6:
		if gun and gun2 and knife and gun3 and gun4 and gun6 != null:
			gun.visible = false
			gun3.visible = false
			gun2.visible = false
			gun4.visible = false
			gun6.visible = true
			knife.visible = false


func weapon_select():
	
	if Input.is_action_just_pressed("Weapon1"):
		current_weapon = 1
		print("1")
		ammo =  2
	
	elif Input.is_action_just_pressed("Weapon2"):
		current_weapon = 2
		print("2")
		ammo = 3
			
	elif Input.is_action_just_pressed("weapon4"):
		current_weapon = 4
		print("4")
		ammo = 6
			
	elif Input.is_action_just_pressed("weapon5"):
		current_weapon = 5
		print("5")
					
	elif Input.is_action_just_pressed("weapon6"):
		current_weapon = 6
		print("6")
		ammo = 30


func ads_scoped():
	if anim != null and FirstPerson.current_weapon == 4:
		ads = 1
		anim.play("ADS")

func ads_unscoped():
	if anim != null and FirstPerson.current_weapon == 4:
		ads = 0
		anim.play_backwards("ADS")



func _physics_process(delta):
	
	weapon_select()
	
	hw()
	
	if health <= 0:
		print("YouAreDead")
		self.global_transform.origin = Vector3(0, 15, 0)
		health = 1
		
	
	direction = Vector3()
	#weapon_select()
	
	#guncam.global_transform = camera.global_transform
	if FirstPerson.current_weapon == 1:
		fire_shotgun_projectile()

		
	elif FirstPerson.current_weapon == 2:
		fire_rifle()
	
	elif current_weapon == 3:
		pass
		#melee()
	elif FirstPerson.current_weapon == 4:
		fire_scoped_sniper()
	
	elif FirstPerson.current_weapon == 5:
		fire_scoped_sniper()
	
	elif FirstPerson.current_weapon == 6:
		fire_assault()

	
	
	
	
	
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
	

	if is_network_master():
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
