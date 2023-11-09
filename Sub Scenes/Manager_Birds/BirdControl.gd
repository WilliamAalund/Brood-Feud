extends Node2D

# Values that each of the birds can refer to in order to make decisions about themselves/what they want to do.
@export var foodRestore = 10
@export var idleSatiationDrainRate = 0.06
@export var sunRate = -0.03
@export var debug = false

var momIsHome = false # Toggled by toggle_mom_presence signal, sent by momma bird.
var isSunspot = false # Toggled in the Main Level scene's attached script.

signal AI_Bird_Move(target_position)
signal Birds_Increment_Hunger()
signal player_starved
signal birds_toggle_predator_notice

func _ready():
	if debug:
		$AI_Bird.debug = true

func _physics_process(_delta):
	emit_signal("AI_Bird_Move", $player_bird.position)

func _on_process_momma_bird_toggle_mom_presence(): 
	momIsHome = !momIsHome

func _on_timer_timeout():
	emit_signal("Birds_Increment_Hunger")

func _on_player_bird_player_starved():
	emit_signal("player_starved")
	
func _on_process_predator_toggle_predator_approach():
	emit_signal("birds_toggle_predator_notice")

func _on_process_predator_predator_leaves_nest():
	emit_signal("birds_toggle_predator_notice")
