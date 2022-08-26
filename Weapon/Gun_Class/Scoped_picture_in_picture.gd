extends Gun

onready var AnimPlayer = $AnimationPlayer
onready var BulletPoint = $BulletPoint
#onready var Emission = $AnimationPlayer
onready var BulletStopTimer = $Timer
#onready var ScopeViewport = $BasicScoped/Viewport
onready var ZoomTween = $ZoomTween
onready var Lens = $BasicScoped/SniperRifle_4/Lens
onready var ZoomOverlay = preload("res://UI/ScopeOverlay_Blur.tscn")

var ZoomVP

var HasShot = false
var BulletDuration: int = 0
var ZoomFOV: float = 70.0
var BaseFOV: float = 70.0
var GunCamFOV: float = 15.0
var Zoomed = false

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
			#Emission.play("Emit")
			BulletDuration += 1
			var _spray = Spray(BulletDuration, Speed)
			emit_signal("SprayCalc", _spray)
			$shotSound.play()
			$shotSound.set_pitch_scale(rand_range(.7,.9))
			ReduceBullets(1)
			CalculateCollision(BulletPoint)
	HasShot = true

func _PrimaryFireReleased():
	HasShot = false
	emit_signal("ResetSpray")
	BulletStopTimer.start()

func _SecondaryFire():
	if AnimPlayer.is_playing() == false:
		Zoomed = true
		#ScopeViewport.set_update_mode(2)
		Lens.set_visible(true)
		emit_signal("Zoomed", ZoomFOV, ZoomTween, GunCamFOV, Zoomed)
		emit_signal("Overlay", Zoomed, ZoomOverlay)
		AnimPlayer.play("ShaderZoom")

func _SecondaryFireReleased():
	if Zoomed == true:
		Zoomed = false
		#ScopeViewport.set_update_mode(0)
		Lens.set_visible(false)
		emit_signal("Zoomed", BaseFOV,ZoomTween,BaseFOV, Zoomed)
		emit_signal("Overlay", Zoomed, ZoomOverlay)	
		AnimPlayer.play("ShaderZoomOut")

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

func _on_Timer_timeout():
	BulletDuration = 0
