extends Node2D

signal toggle_fly

func _ready():
	$character_momma.roost_target_position = $roost_target.global_position
	$character_momma.fly_off_target_position = $fly_off_target.global_position


func _on_momma_bird_toggle_mom_presence():
	emit_signal("toggle_fly")
