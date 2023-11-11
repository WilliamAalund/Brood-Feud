extends Node2D

const TIMES_LANDED_AT_NEST_NEEDED_TO_WIN_GAME = 6

@export var SecondsToReturn = 25
@export var FoodToDrop = 6
@export var DropInterval = 2 # Time momma bird takes between dropping food
@export var LandingTime = 1.5

var goneTimer = 0
var isHome = true # Momma bird starts off at the nest
var predatorIsHome = false # Used to make sure momma bird doesn't come to roost while predator is attacking
var timesLandedAtNest = 0

signal mom_drops_food
signal toggle_mom_presence
signal momma_win_condition

func set_SecondsToReturn(value): # Handles the progress bar changing when the export value changes
	SecondsToReturn = value
	$ProgressBar.max_value = SecondsToReturn

func _ready(): # Momma bird starts off at the nest
	#var momSprite = get_child(0)
	#momSprite.visible = isHome
	$ProgressBar.max_value = SecondsToReturn
	momReturns()

func _on_timer_timeout(): # Function runs every 0.1 seconds
	if (!isHome):
		goneTimer += 0.1 # Incremented by tenths of a second
		$ProgressBar.value = goneTimer
	if !isHome and goneTimer > SecondsToReturn:
		if !predatorIsHome: # Momma bird will not return to the nest if a predator is in the nest.
			print("Momma bird returns")
			isHome = true
			momReturns() # sets isHome to false when end of function is reached
		else: # Momma bird gets scared off by predator
			print("Momma bird scared off from nest")
			goneTimer /= 2

func momReturns(): # Hand
	emit_signal("toggle_mom_presence")
	#var momSprite = get_child(0)
	#momSprite.visible = isHome
	await get_tree().create_timer(LandingTime).timeout
	var foodDropped = 0
	while foodDropped < FoodToDrop:
		emit_signal("mom_drops_food")
		foodDropped += 1
		await get_tree().create_timer(DropInterval).timeout
	isHome = false
	#momSprite.visible = isHome
	goneTimer = 0
	emit_signal("toggle_mom_presence")
	print("Momma bird leaves")
	timesLandedAtNest += 1
	if timesLandedAtNest > TIMES_LANDED_AT_NEST_NEEDED_TO_WIN_GAME:
		emit_signal("momma_win_condition")
	

func _on_process_predator_toggle_predator_presence():
	predatorIsHome = !predatorIsHome

#func _on_predator_toggle_predator_presence():
	#predatorIsHome = !predatorIsHome
