extends Node2D

var gameOver = false

signal game_over_ocurred(reason)

func _ready():
	$Label.visible = false

func _on_process_predator_player_eaten():
	gameOver = true
	$Label.visible = true
	emit_signal("game_over_ocurred", "Don't let the merlin see you when it comes to the nest.")

func _on_manager_birds_player_starved():
	gameOver = true
	$Label.visible = true
	emit_signal("game_over_ocurred", "You starved. Eat food and bask in sunlight to stay satiated.")


func _on_manager_birds_player_grew_up():
	pass # Replace with function body.
