extends Control

func _ready():
	visible = false

func _input(event):
	if event.is_action_pressed("secondaryinteract"):
		if self.visible:
			get_tree().change_scene_to_file("res://Levels/mainmenu.tscn")

func _on_returntomainmenubutton_pressed():
	if self.visible == true:
		get_tree().change_scene_to_file("res://Levels/mainmenu.tscn")
	
