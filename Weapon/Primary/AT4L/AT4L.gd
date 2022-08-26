extends Gun

onready var Rocket = preload("res://Weapon/Primary/AT4L/Rocket.tscn")
onready var RocketPoint = $RocketPoint
onready var AnimPlayer = $AnimationPlayer
onready var BulletStopTimer = $SprayResetTimer
var HasShot: bool = false
var BulletDuration: int = 0
export var RocketSpeed: int = 20
var Zoomed = false
var ZoomFOV: float = 10.0
var BaseFOV: float = 70.0
var GunCamFOV: float = 70.0
onready var ZoomTween = $ZoomTween

func _PrimaryFire(Speed: float = 0.0):
	if AnimPlayer.is_playing() or HasShot:
		return
	else:
		if CurrentAmmo == 0:
			_Reload()
		else:
			$ShotSound.play()
			$ShotSound.set_pitch_scale(rand_range(.7,.9))
			ReduceBullets(1)
			AnimPlayer.play("Kick")
			
			BulletDuration += 1
			
			var _spray = Spray(BulletDuration, Speed)
			var CameraCollission = GetCameraCollission(_spray)
			var Target = CalculateCollision(RocketPoint,CameraCollission)
			
			SpawnRocket(Target)
			
	HasShot = true
	
func SpawnRocket(T_info: Array):
	var DirectionPoint = -RocketPoint.get_global_transform().basis.z #this is just incase there is no target
	var R = Rocket.instance()
	var Scene = get_tree().get_root()
	Scene.add_child(R)
	R.set_global_transform(RocketPoint.get_global_transform())
	DirectionPoint = T_info[2]
	R.set_linear_velocity(DirectionPoint*RocketSpeed)

func _PrimaryFireReleased():
	HasShot = false
	#emit_signal("ResetSpray")
	BulletStopTimer.start()

func _on_SprayResetTimer_timeout():
	BulletDuration = 0

func _Reload():
	if AnimPlayer.is_playing():
		pass
	else:
		if CurrentCapacity > 0:
			#AnimPlayer.play("reload")
			UpdateCapacity()
		else:
			pass
			#AnimPlayer.play("OOA")
	
#	else:
#		DirectionPoint = GetFarPoint()
		
#func _SecondaryFire():
#	Zoomed = true
##	AnimPlayer.play("ads")
#	emit_signal("Zoomed", ZoomFOV, ZoomTween, GunCamFOV, Zoomed)
#
#func _SecondaryFireReleased():
#	Zoomed = false
##	AnimPlayer.play_backwards("ads")
#	emit_signal("Zoomed", BaseFOV,ZoomTween,BaseFOV, Zoomed)	
