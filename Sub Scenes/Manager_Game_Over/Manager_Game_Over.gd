extends Node2D

var gameOver = false

signal game_over_ocurred(reason)

func _ready():
	$Label.visible = false

func _on_process_predator_player_eaten():
	gameOver = true
	$Label.visible = true
	emit_signal("game_over_ocurred", "You were eaten by the predator")

func _on_manager_birds_player_starved():
	gameOver = true
	$Label.visible = true
	emit_signal("game_over_ocurred", "You starved to death")
