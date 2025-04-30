extends Control
#menu script 
@onready var score = $MarginContainer/VBoxContainer/Label

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/main.tscn")


	
	
func _process(_delta):
	var button = $MarginContainer2/VBoxContainer/Button2
	if button and button.is_pressed():
		get_tree().change_scene_to_file("res://scene/infoscreen.tscn")
		
		
func _ready():
	var high_score:int = Global.save_data.high_score
	score.text = "High Score: " + str(high_score)
