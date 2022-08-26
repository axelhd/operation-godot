extends Spatial

const ADS_LERP = 20
var current_weapon = 1

export var deafault_position : Vector3
export var deafault2_position : Vector3
export var ads_position : Vector3
export var ads2_position : Vector3
export var ads3_position : Vector3
export var deafault3_position : Vector3


func weapons():
	if Input.is_action_just_pressed("Weapon1"):
		current_weapon = 1
		print("1")
	
	elif Input.is_action_just_pressed("Weapon2"):
		current_weapon = 2
		print("2")
		
	elif Input.is_action_just_pressed("melee"):
		current_weapon = 3
		print("3")

func _ready():
	pass

func _process(delta):
	
	if FirstPerson.current_weapon == 1:
		if Input.is_action_pressed("fire2"):
			transform.origin = transform.origin.linear_interpolate(ads_position, ADS_LERP * delta)
		else:
			transform.origin = transform.origin.linear_interpolate(deafault_position, ADS_LERP * delta)
	elif FirstPerson.current_weapon == 2:
		if Input.is_action_pressed("fire2"):
			transform.origin = transform.origin.linear_interpolate(ads2_position, ADS_LERP * delta)
		else:
			transform.origin = transform.origin.linear_interpolate(deafault2_position, ADS_LERP * delta)
			
	elif FirstPerson.current_weapon == 4:
		
		if Input.is_action_pressed("fire2"):
			FirstPerson.ads = 1
			transform.origin = transform.origin.linear_interpolate(ads3_position, ADS_LERP * delta)
		else:
			FirstPerson.ads = 0
			transform.origin = transform.origin.linear_interpolate(deafault3_position, ADS_LERP * delta)
