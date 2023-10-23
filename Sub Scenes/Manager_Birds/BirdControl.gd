extends Node2D


var player_position
var momIsHome = false

signal AI_Bird_Move(target_position)
signal AI_Bird_Increment_Hunger()

func _physics_process(delta):
	player_position = $Player.position
	emit_signal("AI_Bird_Move", player_position)

func _on_process_momma_bird_toggle_mom_presence():
	momIsHome = !momIsHome

func _on_timer_timeout():
	emit_signal("AI_Bird_Increment_Hunger")
