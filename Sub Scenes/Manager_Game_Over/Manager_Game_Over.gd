extends Node2D

var gameOver = false

signal game_over_ocurred(reason)

func _ready():
	$Label.visible = false

func _on_process_predator_player_eaten():
	gameOver = true
	$Label.visible = true
	emit_signal("game_over_ocurred", "Hide at the bottom of the nest to avoid the Merlin when it arrives.")

func _on_manager_birds_player_starved():
	gameOver = true
	$Label.visible = true
	emit_signal("game_over_ocurred", "You starved. Eat food and bask in sunlight to stay satiated.")

func _on_manager_birds_player_killed_by_ai_bird():
	emit_signal("game_over_ocurred", "A broodmate killed you. Pick your targets carefully, and attack from advantageous angles.")

func _on_manager_birds_player_grew_up():
	$victory_screech.play()
	pass # Replace with function body.


