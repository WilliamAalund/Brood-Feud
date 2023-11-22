extends Control

var buttonFocused = 1 # Represents which button is focused on 

func _ready():
	print("Ready function called")
	$MarginContainer/HBoxContainer/VBoxContainer/MenuOptions/directionsButton.grab_focus()
	
	# Assuming your button is a direct child of the Control node.
	# Replace "startButton" with the actual name of your button node.

func _process(_delta):
	if Input.is_action_just_pressed("interact"): # If the player uses the interact key instead of the mouse
		match buttonFocused:
			1:
				_on_directions_button_pressed()
			2:
				_on_start_button_pressed()
			3:
				_on_credits_button_pressed()
			4:
				_on_quit_button_pressed()

func _on_start_button_pressed():
	print("Start button pressed!")
	# Change the scene to the main level
	get_tree().change_scene_to_file("res://Levels/Main Level.tscn")

func _on_start_button_focus_entered():
	print("Start button is focused on")
	buttonFocused = 2

func _on_directions_button_pressed():
	print("Directions button pressed!")
	get_tree().change_scene_to_file("res://Levels/directions.tscn")

func _on_directions_button_focus_entered():
	print("Directions button is focused on")
	buttonFocused = 1

func _on_credits_button_pressed():
	get_tree().change_scene_to_file("res://Levels/credits.tscn")

func _on_credits_button_focus_entered():
	print("Credits button is focused on")
	buttonFocused = 3

func _on_quit_button_pressed():
	get_tree().quit();

func _on_quit_button_focus_entered():
	print("Quit button is focused on")
	buttonFocused = 4
