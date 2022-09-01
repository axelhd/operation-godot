extends Control



func _ready():
	Global.connect("toggle_network_setup", self, "_toggle_network_setup")

func _on_IpAddress_text_changed(new_text):
	Network.ip_address = new_text
	


func _on_Host_pressed():
	print("Host pressed")
	print(Network.ip_address)
	Fps.hide_ns()
	Network.create_server()
	print("Server created")
	
	#get_tree().change_scene("res://UI.tscn")
	
	Global.emit_signal("instace_player", get_tree().get_network_unique_id())


func _on_Join_pressed():
	Fps.hide_ns()
	
	Network.join_server()
	#get_tree().change_scene("res://UI.tscn")
	

func _toggle_network_setup(visible_toggle):
	visible = visible_toggle
