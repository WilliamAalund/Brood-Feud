extends Node2D
@export var satiationValue = 100
@export var starvationThreshold = 30
@export var angryThreshold = 5

var state = 0 # Bird begins inside of an egg
var aggroVal = 0 # Bird begins with no aggro value TODO: Implement aggroVal raising
var aggroTarget
var momHome # TODO: Find way to alert bird that momma bird is home
var isSunspot
var noticedPredator
var isStupid

var Player_Pos # Variable to store the location of the player
#TODO: Make sure

func _ready(): # Will be removed later on when the bird should actually start in the nest
	updateState()

# -- STATE DESCRIPTIONS --
# 0 - In egg
# 1 - Idle
# 2 - Focused on food
# 3 - Focused on player/other bird. Focus dictated by aggroTarget
# 4 - Focused on moving to sunspot
# 5 - Focused on hiding from predator
# 6 - Dead

# If the bird is dead its dead, won't do anything.
# The next thing that will take over is fight or flight. If the bird is scared or angry it will
# prioritize that.
# If the bird isn't starving
func updateState():
	if satiationValue <= 0:
		state = 6 # Dead
	else: if noticedPredator and not isStupid:
		state = 5 # Running away from predator
	else: if aggroVal >= angryThreshold:
		state = 3
	else: if momHome or satiationValue < starvationThreshold:
		state = 2
	else: if isSunspot:
		state = 4 # Seeking out sunspot
	else:
		state = 1 # Idle

# TODO: Aparrently, you can pass functions as parameters.
# There should be an extremely easy way to tell the navigation agent to just do 
# x navigation behavior, where x is just the state value.
# TODO: Figure out a way to call updateState that isn't super intensive.

func _on_bird_control_ai_bird_move(target_position):
	$CharacterBody2D.target = target_position # Replace with function body.
	

func _on_timer_timeout():
	updateState()
	print("AI bird  : state updated to: " + str(state))
	$CharacterBody2D.state = state
