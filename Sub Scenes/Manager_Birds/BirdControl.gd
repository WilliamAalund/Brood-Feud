extends Node2D

# Values that each of the birds can refer to in order to make decisions about themselves/what they want to do.
# These values are usually updated outside of the BirdControl script itself
@export var idleSatiationDrainRate = 0.06

var momIsHome = false # Toggled by toggle_mom_presence signal, sent by momma bird.
var isSunspot = false # Toggled in the Main Level scene's attached script.

signal AI_Bird_Move(target_position)
signal Birds_Increment_Hunger()
signal playerStarved()

func _physics_process(_delta):
	emit_signal("AI_Bird_Move", $Player.position)

func _on_process_momma_bird_toggle_mom_presence(): 
	momIsHome = !momIsHome

func _on_timer_timeout():
	emit_signal("Birds_Increment_Hunger")

func _on_player_player_starved(): # Communicated with the Manager_Game_Over node.
	emit_signal("playerStarved()")
