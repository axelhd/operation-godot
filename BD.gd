extends Spatial
var current_weapon = null


onready var raycontainer = $FP/FirstPerson/Head/Camera/RayContainer
onready var pRay = $FP/FirstPerson/Head/Camera/RayCast

onready var blood_splatter = preload("res://BloodSplatter.tscn")
onready var b_decal = preload("res://ShotgunDecal.tscn")
onready var b_decal2 = preload("res://BulletDecal.tscn")

onready var FP = get_node("res://FirstPerson.gd")

func _ready():
	pass
	
func PistolHoles():
	if Input.is_action_just_pressed("fire"):
		if pRay.is_colliding():
				var bd = b_decal2.instance()
				
				
				pRay.get_collider().add_child(bd)
				bd.global_transform.origin = pRay.get_collision_point()
				bd.look_at(pRay.get_collision_point() + pRay.get_collision_normal(), Vector3.UP)
				var bs = blood_splatter.instance()
				pRay.get_collider().add_child(bs)
				bs.global_transform.origin = pRay.get_collision_point()
				bs.look_at(pRay.get_collision_point() + pRay.get_collision_normal(), Vector3.UP)

		
func ShotGunHoles():
	if Input.is_action_just_pressed("fire"):
		#var shots = Array()
		var shots = Array()
		for shot in range(0, 50):
			shots.append(b_decal.instance())
		
		var i = 0
		for raycast in raycontainer.get_children():
			var b = shots[i]
			i = i+1
			if raycast.is_colliding():
				#print(b)
				raycast.get_collider().add_child(b)
				b.global_transform.origin = raycast.get_collision_point()
				b.look_at(raycast.get_collision_point() + raycast.get_collision_normal(), Vector3.UP)
				var bs = blood_splatter.instance()
				raycast.get_collider().add_child(bs)				
				bs.global_transform.origin = raycast.get_collision_point()
				bs.look_at(raycast.get_collision_point() + raycast.get_collision_normal(), Vector3.UP)
		
			
#func PistolHoles():
	#var b5 = b_decal.instance()
	#if raycast.is_colliding():
			#raycast.get_collider().add_child(b5)
			#b5.global_transform.origin = raycast.get_collision_point()
			#b5.look_at(raycast.get_collision_point() + raycast.get_collision_normal(), Vector3.UP)
			
func _process(delta):
	
	if FirstPerson.current_weapon == 1:
		ShotGunHoles()
	
	elif FirstPerson.current_weapon == 2:
		PistolHoles()
		
	elif FirstPerson.current_weapon == 3:
		pass
		
