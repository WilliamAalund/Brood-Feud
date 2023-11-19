extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$MarginContainer/CenterContainer/VBoxContainer/backButton.grab_focus()

func _process(delta):
	if Input.is_action_just_pressed("secondaryinteract") or Input.is_action_just_pressed("interact"): # If the player uses the interact key instead of the mouse
		_on_back_button_pressed()

func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://Levels/mainmenu.tscn")
