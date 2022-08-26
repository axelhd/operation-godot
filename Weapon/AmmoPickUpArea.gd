extends Area

export var AmmoType: String = "Rifle" ##This needs to match exactly the node name of your gun or it will not work!!!
export var Amount: int = 30
export var Expendable: bool = true

onready var PickUpSound = $AudioStreamPlayer3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_PickUpArea_body_entered(body):
	var Taken = body.PickUpAmmo(AmmoType, Amount)
	
	if Amount == Amount-Taken:
		pass
	else:
		PickUpSound.play()
		
	Amount = int(min(Amount - Taken, Amount))

	yield(get_tree().create_timer(.15),"timeout")
	
	if Amount <= 0 && Expendable:
		owner.queue_free()
		
