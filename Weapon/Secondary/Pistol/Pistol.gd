extends Gun

onready var AnimPlayer = $AnimationPlayer
onready var BulletPoint = $BulletPoint
onready var Emission = $BulletPoint/Shot/AnimationPlayer
onready var BulletStopTimer = $Timer

var HasShot = false
var BulletDuration: int = 0

func _ready():
	pass

func _PrimaryFire(Speed: float = 0.0):
	if AnimPlayer.is_playing() or HasShot:
		return
	else:
		if CurrentAmmo == 0:
			_Reload()
		else:
			AnimPlayer.play("Kick")
			Emission.play("Emit")
			BulletDuration += 1
			var _spray = Spray(BulletDuration, Speed)
			emit_signal("SprayCalc", _spray)
			$shotSound.set_pitch_scale(rand_range(.7,.9))
			ReduceBullets(1)
			var CameraCollission = GetCameraCollission(_spray)
			if CameraCollission != null:
				var Target = CalculateCollision(BulletPoint,CameraCollission)
				if Target[0] == true:
					HitScanDamage(Target[1], BulletPoint.get_global_transform().origin, 1)
	HasShot = true

func _PrimaryFireReleased():
	HasShot = false
	emit_signal("ResetSpray")
	BulletStopTimer.start()

func _Reload():
	if AnimPlayer.is_playing():
		pass
	else:
		if CurrentCapacity > 0:
			AnimPlayer.play("reload")
			UpdateCapacity()
		else:
			AnimPlayer.play("OOA")
		


func _on_Timer_timeout():
	BulletDuration = 0
