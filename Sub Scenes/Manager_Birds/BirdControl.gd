extends Node2D

# Values that each of the birds can refer to in order to make decisions about themselves/what they want to do.
@export var debug = false

var isSunspot = false # Toggled in the Main Level scene's attached script.

#signal AI_Bird_Move(target_position)
signal Birds_Increment_Hunger()
signal player_starved
signal player_grew_up
signal player_attacked
signal player_killed_by_ai_bird
signal birds_toggle_predator_notice
signal birds_toggle_momma_bird_notice
signal kill
signal pred_spot
signal ai_birds_enter_debug_mode


func _ready():
	if debug:
		emit_signal("ai_birds_enter_debug_mode")
		#$AI_Bird.debug = true
	var dumbBird = get_child(4)
	dumbBird.makeBirdStupid()

func _on_process_momma_bird_toggle_mom_presence(): # When mom comes to/leaves nest
	emit_signal("birds_toggle_momma_bird_notice")

func _on_timer_timeout(): # Tells birds to increment hunger values
	emit_signal("Birds_Increment_Hunger")

func _on_player_bird_player_starved(): # When the player starves
	emit_signal("player_starved")
	
func _on_process_predator_toggle_predator_approach(): # When the predator has approached the nest, but is not at the nest yet
	emit_signal("birds_toggle_predator_notice")

func _on_process_predator_predator_leaves_nest(): # When the predator leaves the nest
	emit_signal("birds_toggle_predator_notice")


func _on_player_bird_player_grew_up():
	emit_signal("player_grew_up")

func _on_player_bird_player_attacked():
	emit_signal("player_attacked")

func _on_process_predator_pred_position(place):
	emit_signal("pred_spot",place)

func _on_process_predator_bird_eaten(bird):
	print("kill switch sent")
	emit_signal("kill",bird)

# Signals from the final version of the player bird
func _on_player_bird_2_player_grew_up():
	emit_signal("player_grew_up")

func _on_player_bird_2_player_starved():
	emit_signal("player_starved")

func _on_player_bird_2_player_attacked():
	emit_signal("player_attacked")

func _on_player_bird_2_player_killed_by_ai_bird():
	emit_signal("player_killed_by_ai_bird")
