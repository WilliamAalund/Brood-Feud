extends Node2D

@export var LandingTime = 1.5

var goneTimer = 0
var isHome = true # Momma bird starts in the nest 
var predatorIsHome = false # Used to make sure momma bird doesn't come to roost while predator is attacking
var timesLandedAtNest = 0 # Keeps track of every complete time momma bird lands at the nest. Not used for anything

signal mom_drops_food 
signal toggle_mom_presence
signal momma_win_condition
signal new_food_position_for_rig(foodpos)

func _ready():
	$ProgressBar.max_value = Game_Parameters.SECONDS_TO_RETURN_TO_NEST # Progress bar used for debugging
	momReturns() # Momma bird starts in the nest

func _on_timer_timeout(): # Function runs every 0.1 seconds
	if (!isHome):
		goneTimer += 0.1 # Incremented by tenths of a second
		$ProgressBar.value = goneTimer
	if !isHome and goneTimer > Game_Parameters.SECONDS_TO_RETURN_TO_NEST:
		if !predatorIsHome: # Momma bird will not return to the nest if a predator is in the nest.
			print("Momma bird returns")
			isHome = true
			momReturns() # sets isHome to false when end of function is reached
		else: # Momma bird gets scared off by predator
			print("Momma bird scared off from nest")
			goneTimer /= 2

func momReturns(): 
	emit_signal("toggle_mom_presence")
	$mommabird.play()
	await get_tree().create_timer(Game_Parameters.TIME_TO_LAND_IN_SECONDS).timeout
	var foodDropped = 0
	while foodDropped < Game_Parameters.FOOD_PIECES_TO_DROP: # Drop a certain amount of food pieces
		emit_signal("mom_drops_food")
		foodDropped += 1
		await get_tree().create_timer(Game_Parameters.FOOD_DROP_INTERVAL_IN_SECONDS).timeout
	isHome = false
	goneTimer = 0
	emit_signal("toggle_mom_presence")
	print("Momma bird leaves")
	timesLandedAtNest += 1

func _on_process_predator_toggle_predator_presence():
	predatorIsHome = !predatorIsHome

func _on_helper_food_spawner_new_food_position(foodpos):
	emit_signal("new_food_position_for_rig", foodpos)
