extends Control

func _ready():
	visible = false
	


func _on_returntomainmenubutton_pressed():
	if self.visible == true:
		get_tree().change_scene_to_file("res://Levels/mainmenu.tscn")
	
