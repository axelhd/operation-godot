extends Gun

onready var AnimPlayer = $AnimationPlayer
onready var BulletPoint = $BulletPoint
onready var Sounds = $Sounds
onready var RoTween = $RotTween

var SoundsArray
var SoundCount = 0

var BulletDuration: int = 0

func _ready():
	SoundsArray = Sounds.get_children()
	
func _PrimaryFire(Speed: float = 0.0):
	if AnimPlayer.is_playing():
		pass
	else:
		if CurrentAmmo == 0:
			_Reload()
		else:
			AnimPlayer.play("Kick")
			SoundsArray[SoundCount].play()
			SoundCount += 1
			if SoundCount == SoundsArray.size():
				SoundCount = 0
			ReduceBullets(1)
			
			BulletDuration += 1
			
			var _spray = Spray(BulletDuration, Speed)
			emit_signal("SprayCalc", _spray)
			#set_rotation_degrees(Vector3(min(_spray.y/2,12),0,0))
			
			var CameraCollission = GetCameraCollission(_spray)
			if CameraCollission != null:
				var Target = CalculateCollision(BulletPoint,CameraCollission)
				if Target[0] == true:
					HitScanDamage(Target[1], BulletPoint.get_global_transform().origin, 1)
			emit_signal("AmmoUpdate", CurrentAmmo, CurrentCapacity)

func _PrimaryFireReleased():
	var OldRotaion = get_rotation_degrees()
	BulletDuration = 0
	h=0
	emit_signal("ResetSpray")
	RoTween.interpolate_method($".","set_rotation_degrees",OldRotaion,Vector3(0,0,0),.3,Tween.TRANS_LINEAR,Tween.EASE_OUT)
	RoTween.start()
	

func _Reload():
	if AnimPlayer.is_playing():
		pass
	else:
		if CurrentCapacity > 0:
			AnimPlayer.play("reload")
			UpdateCapacity()
		else:
			AnimPlayer.play("OOA")
		
