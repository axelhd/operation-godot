extends Gun

onready var AnimPlayer = $AnimationPlayer
onready var BulletPoint = $AssaultRifle2_2/BulletPoint
onready var Sounds = $Sounds
onready var RoTween = $RotTween
onready var ZoomTween = $ZoomTween

var SoundsArray
var SoundCount = 0
var BulletsFired = 1

var ZoomFOV: float = 50.0
var BaseFOV: float = 70.0
var GunCamFOV: float = 30.0
var Zoomed = false

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
			ReduceBullets(BulletsFired)
			
			BulletDuration += BulletsFired
			
			var _spray = Spray(BulletDuration, Speed)
			NewSpray = NewSpray +_spray
			emit_signal("SprayCalc", _spray)
		
			set_rotation_degrees(Vector3(deg2rad(_spray.y),0,0))
			var CameraCollission = GetCameraCollission(NewSpray)
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
	NewSpray = Vector3.ZERO
	RoTween.interpolate_method($".","set_rotation_degrees",OldRotaion,Vector3(0,0,0),.3,Tween.TRANS_LINEAR,Tween.EASE_OUT)
	RoTween.start()

func _SecondaryFire():
	Zoomed = true
	AnimPlayer.play("ads")
	emit_signal("Zoomed", ZoomFOV, ZoomTween, GunCamFOV, Zoomed)

func _SecondaryFireReleased():
	Zoomed = false
	AnimPlayer.play_backwards("ads")
	emit_signal("Zoomed", BaseFOV,ZoomTween,BaseFOV, Zoomed)	

func _Reload():
	if AnimPlayer.is_playing():
		pass
	else:
		if CurrentCapacity > 0:
			if Zoomed == true:
				_SecondaryFireReleased()
			AnimPlayer.play("reload")
			UpdateCapacity()
		else:
			AnimPlayer.play("OOA")
		
