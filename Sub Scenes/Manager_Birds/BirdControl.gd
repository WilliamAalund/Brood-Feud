extends Node2D

# Values that each of the birds can refer to in order to make decisions about themselves/what they want to do.
@export var foodRestore = 8
@export var idleSatiationDrainRate = 0.06
@export var sunRate = -0.03
@export var debug = false

var momIsHome = false # Toggled by toggle_mom_presence signal, sent by momma bird.
var isSunspot = false # Toggled in the Main Level scene's attached script.

#signal AI_Bird_Move(target_position)
signal Birds_Increment_Hunger()
signal player_starved
signal birds_toggle_predator_notice
signal birds_toggle_momma_bird_notice

func _ready():
	if debug:
		$AI_Bird.debug = true

func _on_process_momma_bird_toggle_mom_presence(): # When mom comes to/leaves nest
	momIsHome = !momIsHome

func _on_timer_timeout(): # Tells birds to increment hunger values
	emit_signal("Birds_Increment_Hunger")

func _on_player_bird_player_starved(): # When the player starves
	emit_signal("player_starved")
	
func _on_process_predator_toggle_predator_approach(): # When the predator has approached the nest, but is not at the nest yet
	emit_signal("birds_toggle_predator_notice")

func _on_process_predator_predator_leaves_nest(): # When the predator leaves the nest
	emit_signal("birds_toggle_predator_notice")
