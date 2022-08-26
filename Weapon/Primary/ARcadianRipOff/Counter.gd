extends Viewport

onready var CounterLabel = $CanvasLayer/Label
onready var ColorCounter = $CanvasLayer/ColorRect

var MaxCap: float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func CountAmmo(number, _capacity):
	CounterLabel.set_text(String(number))
	
	ColorCounter.color = Color((MaxCap-number)/MaxCap,number/MaxCap,0,1)
