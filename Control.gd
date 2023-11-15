extends Control

func _ready():
	print("Ready function called")
	$MarginContainer/HBoxContainer/VBoxContainer/MenuOptions/startButton.grab_focus()
	
	# Assuming your button is a direct child of the Control node.
	# Replace "startButton" with the actual name of your button node.

func _process(delta):
	# This function will be called every frame as long as a node has input focus
	if Input.is_action_pressed("interact"):
		# Respond to the "ui_accept" input action (e.g., a button press)
		pass

func _on_start_button_pressed():
	print("Start button pressed!")
	# Change the scene to the main level
	get_tree().change_scene_to_file("res://Levels/Main Level.tscn")

func _on_directions_button_pressed():
	print("Directions button pressed!")
	get_tree().change_scene_to_file("res://Levels/directions.tscn")

func _on_quit_button_pressed():
	get_tree().quit();

func _on_credits_button_pressed():
	get_tree().change_scene_to_file("res://Levels/credits.tscn")



