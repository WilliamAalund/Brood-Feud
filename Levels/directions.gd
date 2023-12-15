extends Node2D

func _ready():
	var userGamepad = Input.get_joy_name(0)
	if userGamepad == "":
		print("User is playing with a mouse and keyboard.")
		$"Keyboard Directions".visible = true
	else: if userGamepad == "PS5 Controller" or userGamepad == "PS4 Controller":
		print("User is playing with a Playstation controller.")
		$"PS5 Directions".visible = true
	else: if userGamepad == "XInput Gamepad":
		print("User is playing with an Xbox controller.")
		$"Xbox Directions".visible = true
	
func _process(_delta):
	if Input.is_action_just_pressed("secondaryinteract"): # If the player uses the interact key instead of the mouse
		_on_back_button_pressed()

func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://Levels/mainmenu.tscn")
