extends Node2D

@export var weak_magnitude = 1.0
@export var strong_magnitude = 1.0


func _input(event):
	if event.is_action_pressed("interact"):
		Input.start_joy_vibration(0, weak_magnitude, strong_magnitude, 0.15)
	else: if event.is_action_pressed("secondaryinteract"):
		Input.start_joy_vibration(0, strong_magnitude, weak_magnitude, 0.1)
