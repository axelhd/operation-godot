extends CanvasLayer



func _ready():
	pass

func _on_Button_pressed():
	FirstPerson.current_weapon = 1
	print("1")
	get_tree().change_scene("res://FPS.tscn")
	print("Scene Changed1")

func _on_Button2_pressed():
	FirstPerson.current_weapon = 2
	print("2")
	get_tree().change_scene("res://FPS.tscn")
	print("Scene Changed2")


func _on_Button3_pressed():
	FirstPerson.current_weapon = 5
	print("5")
	get_tree().change_scene("res://FPS.tscn")
	print("Scene Changed3")
