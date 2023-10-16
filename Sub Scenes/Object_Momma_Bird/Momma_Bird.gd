extends Node2D


@export var SecondsToReturn = 10
@export var FoodToDrop = 3
@export var DropInterval = 4 # Time momma bird takes between dropping food
@export var LandingTime = 1.5

var goneTimer = 0
var isHome = false
var predatorIsHome = false

signal mom_drops_food
signal toggle_mom_presence

func set_SecondsToReturn(value): # Handles the progress bar changing when the export value changes
	SecondsToReturn = value
	$ProgressBar.max_value = SecondsToReturn

func _ready(): # Momma bird starts off invisible
	var momSprite = get_child(0)
	momSprite.visible = isHome
	$ProgressBar.max_value = SecondsToReturn

func _on_timer_timeout():
	if (!isHome):
		goneTimer += 0.1
		$ProgressBar.value = goneTimer
	if goneTimer > SecondsToReturn:
		if !predatorIsHome: # Momma bird will not return to the nest if a predator is in the nest.
			print("Momma bird returns")
			isHome = true
			var momSprite = get_child(0)
			momSprite.visible = isHome
			momReturns()
			goneTimer = 0
		else: # Momma bird gets scared and runs from the nest
			print("Momma bird scared off from nest")
			goneTimer /= 2

func momReturns():
	emit_signal("toggle_mom_presence")
	await get_tree().create_timer(LandingTime).timeout
	var foodDropped = 0
	while foodDropped <= FoodToDrop:
		emit_signal("mom_drops_food")
		foodDropped += 1
		await get_tree().create_timer(DropInterval).timeout
	isHome = false
	var momSprite = get_child(0)
	momSprite.visible = isHome
	emit_signal("toggle_mom_presence")
	print("Momma bird leaves")
	


func _on_predator_toggle_predator_presence():
	predatorIsHome = !predatorIsHome
