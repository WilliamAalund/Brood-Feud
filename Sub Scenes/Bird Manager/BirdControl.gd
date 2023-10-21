extends Node2D


var player_position

signal AI_Bird_Move(target_position)

func _physics_process(delta):
	player_position = $Player.position
	emit_signal("AI_Bird_Move", player_position)
	
#Tie the signal to AI_Bird
#Get AI_Bird to follow
	
