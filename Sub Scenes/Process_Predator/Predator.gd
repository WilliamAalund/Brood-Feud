extends Node2D

# --- NONE OF THIS IS CORRECT ANYMORE ---
# Rate incrementing to 100 in the background
# there is a ratevalue% chance that predator will head to the nest.
# If the predator heads to the nest, there is a 10% chance they will go to the nest every check
# And a 10% chance to leave the nest the next time a role occurs
# If the predator comes to the nest, momma bird cannot return. 
# If you are moving, the bird eats you.
# If you are near the middle of the nest, the bird eats you.
# Future features: the chance the predator comes to the nest will increase depending on noise.
# --- NONE OF THIS IS CORRECT ANYMORE ---


# All of these values are in seconds
const BASE_TIME_AWAY_FROM_NEST = 65
const TIME_AWAY_VARIANCE = 5
const TIME_APPROACHED_MIN = 2
const TIME_APPROACHED_MAX = 4

@export var LandingTime = 0.5
@export var StayLength = 5

var timeAwayFromNest
var timeUntilHeadToNest
var aggressionDecreaseValue = 0
var predIsHome = false
var momIsHome = false
var foundDumbBird = false
var foundPlayerBird = false
var foundBird = false

signal toggle_predator_approach
signal toggle_predator_presence # Indicates to other nodes that the predator is at the nest.
signal player_eaten

func _ready():
	predatorLoop()
	#detectionAnimation()

func predatorLoop():
	while 1 == 1:
		timeAwayFromNest = BASE_TIME_AWAY_FROM_NEST - aggressionDecreaseValue - randi_range(0, TIME_AWAY_VARIANCE)
		$ProgressBar.max_value = timeAwayFromNest
		while timeAwayFromNest >= 0:
			await $Timer.timeout
			#print(timeAwayFromNest)
			timeAwayFromNest -= 1
			$ProgressBar.value = $ProgressBar.max_value - timeAwayFromNest
		# Predator approaches the nest
		emit_signal("toggle_predator_approach")
		print("Predator: Approaches nest")
		timeUntilHeadToNest = randi_range(2, 5)
		while timeUntilHeadToNest >= 0 or momIsHome:
			await $Timer.timeout
			#print(timeUntilHeadToNest)
			if momIsHome:
				print("Predator: cannot approach nest")
				timeUntilHeadToNest = 4
			else:
				timeUntilHeadToNest -= 1
		print("Predator: Heads to nest")
		headToNest()
		while (predIsHome):
			await $Timer.timeout
		print("Predator: Leaves nest")


func detectionAnimation():
	$bird_detector/Sprite2D.visible = true
	$bird_detector/Sprite2D.modulate.a = 1
	var i = 20
	while i > 0:
		$bird_detector/Sprite2D.modulate.a -= .05
		await get_tree().create_timer(0.04).timeout
		i -= 1
	$bird_detector/Sprite2D.visible = false

func evaluateObject(object):
	if object.is_in_group("dumb"):
		foundDumbBird = true
	else: if object.is_in_group("player") and !foundDumbBird:
		foundPlayerBird = true
	else: if object.is_in_group("bird") and !foundDumbBird and !foundPlayerBird:
		foundBird = true
		
func predatorDecision(): # Signal output / functions handling actually eating the birds will go here
	if foundDumbBird:
		print("Predator wants to eat the dumb bird")
	else: if foundPlayerBird:
		print("Predator wants to eat the player")
		emit_signal("player_eaten")
	else: if foundBird:
		print("Predator wants to eat the ai bird")
	else:
		print("Predator doesn't notice any birds")

func headToNest():
	predIsHome = true
	emit_signal("toggle_predator_presence") # Sent to other nodes, makes rig visible
	await get_tree().create_timer(LandingTime).timeout
	detectionAnimation() # Indicates to player what area isn't safe
	foundBird = false
	foundPlayerBird = false
	foundDumbBird = false
	for object in $bird_detector.get_overlapping_areas():
		evaluateObject(object)
	predatorDecision() # Given previous booleans, figure out which bird to eat, if any
	await get_tree().create_timer(StayLength).timeout
	emit_signal("toggle_predator_presence")
	predIsHome = false
	
func _on_process_momma_bird_toggle_mom_presence():
	momIsHome = !momIsHome

#@export var MaxPredAggro = 750
#@export var PredAggroIncrement = 1
#var predAggro = 0
#var predApproached = false

#func approachCheck() -> bool:
#	var check = randi_range(predAggro, MaxPredAggro)
#	$Debug_Roll.text = str(check)
#	#print("Predator : Approach check: ", check)
#	if check == MaxPredAggro:
#		return true
#	else:
#		#print("false")
#		return false
#
#func headCheck() -> bool:
#	if momIsHome:
#		print("Predator : cannot head to nest: momma bird is watching")
#		return false
#	return randi_range(1, 100) > 40 and !momIsHome

#func _on_timer_timeout(): # State machine(?) Every time a second passes, 
#	if !predIsHome:
#		predAggro += PredAggroIncrement # Slightly increments predAggro
#		if predAggro > MaxPredAggro:
#			predAggro = MaxPredAggro
#		#print(predAggro, predAggro / MaxPredAggro)
#		$ProgressBar.value = predAggro
#	if predAggro % 10 == 0 and !predIsHome:
#		if predApproached:
#			if headCheck():
#				print("Predator : heads to nest")
#				predIsHome = true
#				# Run evil predator functions
#				headToNest()
#			else: if momIsHome:
#				pass # Preserves aggression level. Bird will not completely reset: just wait for another chance
#		else: if approachCheck():
#			print("Predator : approaches nest")
#			emit_signal("toggle_predator_approach")
#			predApproached = true
