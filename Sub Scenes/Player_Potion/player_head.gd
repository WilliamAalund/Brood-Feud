extends CharacterBody2D

#for debugging
@export var angle_padding = 0


func get_input():
	look_at(get_global_mouse_position())
	rotation += deg_to_rad(angle_padding)

func _physics_process(delta):
	get_input()
	move_and_slide()
	
	
