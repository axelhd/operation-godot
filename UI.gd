extends CanvasLayer



func _ready():
	pass

func _on_Button_pressed():
	FirstPerson.current_weapon = 1
	print("1")
	get_tree().change_scene("res://FPS.tscn")

func _on_Button2_pressed():
	FirstPerson.current_weapon = 2
	print("2")
	get_tree().change_scene("res://FPS.tscn")


func _on_Button3_pressed():
	FirstPerson.current_weapon = 4
	print("4")
	get_tree().change_scene("res://FPS.tscn")
