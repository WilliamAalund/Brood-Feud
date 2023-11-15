extends Node2D

func _ready():
	print("Ready function called")
	$backButton.grab_focus()

func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://Levels/mainmenu.tscn")
