extends Node2D
@export var satiation = 100
@export var starvationThreshold = 30
@export var angryThreshold = 5

const idleVal = 0.04
const foodRestore = 10

# State variable is in the child CharacterBody2D Node
# TODO: Implement aggroVal raising, aggroTarger, momHome, isSunspot, noticedPredator, and isStupid
var aggroVal = 0 # Bird begins with no aggro value
var aggroTarget
var sunspotTarget
var noticedFood = false
var noticedSunray = false
var noticedPredator
var isStupid = false
var inSunlight = false

var Player_Pos # Variable to store the location of the player
var targetSunray
var targetFood

func _ready(): # Will be removed later on when the bird should actually start in the nest
	$CharacterBody2D.state = updatedState()

# updatedState: returns an integer value that represents the current state that the bird is in.
# This function is used to control the bird's navigation logic, and it will be used to control
# other aspects of each bird as well.

func eat(): # Function called to increase satiation when you eat.
	if satiation + foodRestore > 100:
		satiation = 100
	else:
		satiation += foodRestore

# -- STATE DESCRIPTIONS --
# 0 - In egg
# 1 - Idle
# 2 - Focused on food
# 3 - Focused on player/other bird. Focus dictated by aggroTarget
# 4 - Focused on moving to sunspot
# 5 - Focused on hiding from predator
# 6 - Dead

func updatedState(): # Returns variable corresponding to state. state then used in pathfinding.
	if satiation <= 0: # If the bird is dead its dead, won't do anything.
		return 6 # Dead
	else: if noticedPredator and not isStupid: # The next thing that will take 
# over is fight or flight. If the bird is scared or angry it will prioritize that.
# Unless it is a stupid bird.
		return 5
	else: if aggroVal >= angryThreshold: # If the bird isn't starving, it will respond to
# aggression from the player, as well as from other birds.
		return 3
	else: if get_parent().momIsHome or satiation < starvationThreshold or noticedFood: # If the bird isn't dead,
# if there is no predator, if the bird isnt angry, and mom is home or the bird is
# starving, it will look for food.
		return 2
	else: if noticedSunray: # If all of the other conditions aren't met, and the bird sees
# a sunspot, then it will seek out the sunspot.
		return 4
	else: # If the bird isn't dead, there is no predator, it isn't angry, it is not
# starving, mom isn't home, and there is no sunspot to seek out, then the bird will
# remain idle.
		return 1 # Idle

func _on_bird_control_ai_bird_move(target_position):
	$CharacterBody2D.target = target_position # Replace with function body.

func _on_timer_timeout():
	$CharacterBody2D.state = updatedState()
	$CharacterBody2D/Debug_AI_State.text = str($CharacterBody2D.state)
	#print("AI bird  : state updated to: " + str($CharacterBody2D.state))

func _on_bird_control_birds_increment_hunger():
	satiation -= get_parent().idleSatiationDrainRate
	$CharacterBody2D/Debug_Satiation_Label.text = str(satiation).substr(0,5)

func _on_body_zone_area_entered(area):
	if area.is_in_group("sunray"):
		await get_tree().create_timer(1.0).timeout
		inSunlight = true
	else: if area.is_in_group("food"):
		eat()

func _on_body_zone_area_exited(area):
	if area.is_in_group("sunray"):
		inSunlight = false

func _on_detector_zone_area_entered(area):
	#print("Entering Area Position: ", area.global_position)
	if area.is_in_group("sunray"):
		if !noticedSunray:
			targetSunray = area.global_position
			noticedSunray = true
	else: if area.is_in_group("food"):
		if !noticedFood:
			targetFood = area.global_position
			noticedFood = true

func _on_detector_zone_area_exited(area):
	if area.is_in_group("sunray"):
		noticedSunray = false
	else: if area.is_in_group("food"):
		noticedFood = false
