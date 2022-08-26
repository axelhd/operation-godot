extends RigidBody

class_name Gun
## Primary Class for Guns. 
## Each Gun Should have these functions implement the below functions

signal AmmoUpdate
signal HitSuccessful
signal SprayCalc
signal ResetSpray
signal Zoomed
signal Overlay

export var CurrentAmmo: int
export var CurrentCapacity: int
export var MagazineCapacity: int
export var MaxAmmo: int
export var UID: String
export var GunMeshParent: NodePath
export(String, "Primary", "Secondary", "Melee", "Throwing") var Type = "Primary"

export var SprayVectors: PoolVector2Array
var h:float = 0
var ModTracker: float = 0
var GunVariables
export(int, 1,10,.5) var SpayScale
#var OldSpray
var NewSpray: Vector3 = Vector3.ZERO


onready var Bullet_debug = preload("res://Weapon/Gun_Class/BulletPoint.tscn")
onready var PickUpArea = preload("res://Weapon/PickUpArea.tscn")
onready var RayCastDebug = preload("res://UI/Ray Cast Debug.tscn")

#redefine in your gun's script. Here to prevent crashing if the gun does not use these functions and also to remind you.
func _PrimaryFire(_Speed: float = 0.0):
	return  

func _SecondaryFire():
	return

func _Reload():
	return

func _PrimaryFireReleased():
	return
	
func _SecondaryFireReleased():
	return

#Call this during the reload function to
func UpdateCapacity():
	var AmmoDeficit = MagazineCapacity - CurrentAmmo
	
	CurrentAmmo = int(min(AmmoDeficit + CurrentAmmo, CurrentAmmo + CurrentCapacity))
	CurrentCapacity = int(max(CurrentCapacity - AmmoDeficit,0)) #reduce the total capacity
	emit_signal("AmmoUpdate", CurrentAmmo, CurrentCapacity)

func ReduceBullets(Amount: int):
	CurrentAmmo = CurrentAmmo - Amount
	emit_signal("AmmoUpdate", CurrentAmmo, CurrentCapacity)


func GetCameraCollission(_spray)->Vector3:
	# TODO Add Spray Calculations to this!		
	# Call this during the Primary/Secondary to detect a hit from the camera. 
	# Returns Collission information, pass on to CalculateCollision to test if there is no obsctruction between
	# Target and gun
	
	var _Camera = get_viewport().get_camera()
	var _Viewport = get_viewport().get_size()
	
	var RayOrigin = _Camera.project_ray_origin(_Viewport/2)
	var RayEnd = (RayOrigin + _Camera.project_ray_normal(_Viewport/2)*2000)+_spray
	
	var Intersection = get_world().direct_space_state.intersect_ray(RayOrigin, RayEnd)
	if not Intersection.empty():
		var ColPoint = Intersection.position
		
		#DEBUG VISUAL#
#		var rd = RayCastDebug.instance() 
#		rd.global_translate(ColPoint)
#		var world = get_tree().get_root()
#		world.add_child(rd)

		return ColPoint
	else:
		return RayEnd
	
#Call this during the Primary/Secondary to detect a hit After Testing For a Camera Colission
func CalculateCollision(Point:Position3D, CollisionPoint: Vector3 = Vector3(0,0,0))->Array:
	var Bullet = get_world().direct_space_state
	
	var HitPoint = CollisionPoint
	var BulletDirection = (HitPoint-Point.global_transform.origin).normalized()
	var FarPointDirection = (CollisionPoint-Point.global_transform.origin).normalized()
	
	var GunCastCollision = Bullet.intersect_ray(Point.global_transform.origin,
	HitPoint+BulletDirection*2)
	
	## This could probably be rolled up into GetCameraCollission
	## At this point in the flow we know if there is a hit already.
	if GunCastCollision:
		return [true, GunCastCollision.collider, BulletDirection] #at somepoint return the surface information for Impact
	else:
		return [false,0,FarPointDirection]

func HitScanDamage(Target, Direction: Vector3, Force:int):
	if Target.is_in_group("enemy"):
	#	print("Hit: ", Target.is_in_group("enemy")," ", Target)
		emit_signal("HitSuccessful")
		Target.TakeDamage(Direction, Force) #This needs to be changed to the position of the MuzzlePoint

func Spray(Count:int, Mod: float = 0.0):
	Mod = round(Mod)
	ModTracker += Mod
	
	h = sqrt(pow(SpayScale+Mod,2)+pow(h,2))
	var A = Count%SprayVectors.size()
	var Spray = Vector3(h*SprayVectors[A].x,h*SprayVectors[A].y,0)
	
	if Mod == 0 && ModTracker>1 or Count == 1:
		h = 0
		ModTracker = 0
	
	return Spray
	
func CheckCapacity(RefilAmount: int):
	var NewCapacity = CurrentCapacity + RefilAmount
	var AdjustedCapacity = min(RefilAmount - (NewCapacity-MaxAmmo), RefilAmount)
	CurrentCapacity += AdjustedCapacity
	return AdjustedCapacity
	
func Drop():
	var DroppedGun = load(get_filename())
	var PickUp = PickUpArea.instance()
	
	DroppedGun = DroppedGun.instance()
	DroppedGun.add_child(PickUp)
	
	DroppedGun.CurrentAmmo = CurrentAmmo
	DroppedGun.CurrentCapacity = CurrentCapacity
	DroppedGun.global_transform = global_transform

	for c in DroppedGun.get_children():
		if c.get_class() == "MeshInstance":
			c.set_layer_mask(1)
	
	var ParentScene = get_tree().get_root().get_child(0)
	ParentScene.add_child(DroppedGun)
	DroppedGun.apply_impulse(Vector3(0,0,0), -((global_transform.basis.z-global_transform.basis.y).normalized())*Vector3(5,5,5))
	
	queue_free()
	
func InitGun(Ammo = CurrentAmmo, Capacity = CurrentCapacity):
	var MeshParent = get_node(GunMeshParent)
	for c in MeshParent.get_children():
		if c.get_class() == "MeshInstance":
			c.set_layer_mask(524288)
	set_collision_mask(0)
	set_mode(1)

	CurrentAmmo = Ammo
	CurrentCapacity = Capacity
