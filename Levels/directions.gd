extends Node2D

func _ready():
	pass
	
func _process(delta):
	if Input.is_action_just_pressed("secondaryinteract"): # If the player uses the interact key instead of the mouse
		_on_back_button_pressed()

func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://Levels/mainmenu.tscn")
