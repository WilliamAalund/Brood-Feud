extends Node2D

var gameOver = false

func _ready():
	$Label.visible = false

# TODO: Receive signal indicating player has been eaten


func _on_hunger_control_player_starved():
	gameOver = true
	$Label.visible = true

func _on_bird_control_player_starved():
	gameOver = true
	$Label.visible = true

#func _on_manager_satiation_player_starved():
	#gameOver = true
	#$Label.visible = true
