extends Node2D

var gameOver = false

signal game_over_ocurred

func _ready():
	$Label.visible = false

# TODO: Receive signal indicating player has been eaten
func _on_bird_control_player_starved():
	gameOver = true
	$Label.visible = true
	emit_signal("game_over_ocurred")


func _on_process_predator_player_eaten():
	gameOver = true
	$Label.visible = true
	emit_signal("game_over_ocurred")