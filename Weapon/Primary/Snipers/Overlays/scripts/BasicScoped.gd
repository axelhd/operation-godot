extends Spatial

onready var ViewPortCamera = $Viewport/ZoomCamera
onready var ScopePosition = $CameraPos

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	ViewPortCamera.global_transform = ScopePosition.global_transform
