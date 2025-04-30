extends Control
#info screen script

func _process(_delta):
	var button = $MarginContainer2/VBoxContainer/Button2
	if button and button.is_pressed():
		get_tree().change_scene_to_file("res://scene/startmenu.tscn")
