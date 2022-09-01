extends Spatial

onready var ZoomPos = $Sniper_1A/CamPos
onready var ZoomCam = $Sniper_1A/Viewport/ZoomCamera

func _ready():
	pass

func _process(delta):
	if ZoomCam and ZoomPos != null:
		ZoomCam.global_transform = ZoomPos.global_transform
		
