extends Node2D

# All of these values are in seconds
const BASE_TIME_AWAY_FROM_NEST = 55 # The base time that the predator will wait intil approaching the nest
const TIME_AWAY_STALL = 4 # The time that the predator will wait after attempting to approach, but being blocked by momma bird
const TIME_AWAY_VARIANCE = 5 # The maximum amount of variance in the time that the predator will wait to approach the nest
const TIME_APPROACHED_MIN = 2 # The minimum amount of time the predator will stay approached before heading to the nest
const TIME_APPROACHED_MAX = 4 # The maximum amount of time the predator will stay approached before heading to the nest
const TIME_APPROACHED_STALL = 4 # The time that the predator will wait after attempting to head to the nest, but was blocked by momma bird

@export var LandingTime = 0.5
@export var StayLength = 3

var timeAwayFromNest
var timeUntilHeadToNest
var aggressionTimeDecrease = 0
var predIsHome = false
var momIsHome = false
var foundDumbBird = false
var foundPlayerBird = false
var foundBird = false
var target = null #bird to be eaten

signal toggle_predator_approach
signal toggle_predator_presence # Indicates to other nodes that the predator is at the nest.
signal predator_leaves_nest
signal player_eaten
signal pred_position
signal bird_eaten

func _ready():
	predatorLoop()
	#detectionAnimation()

# --- PREDATOR LOOP ---
# Always running in the background
# Predator initially waits the base time to be away from the nest (minus a potential variance value)
# Time is measures in seconds.
# Once this time is up, the predator will attempt to "approach" the nest. If momma bird is home, the predator will not approach
# The predator will then spend between 2 to 5 seconds "approached" before actually heading to the nest. The predator will not approach if they were blocked by momma bird
# Then the predator will head to the nest, and run the script handing that event.
# After the predator leaves the nest, the time until the next predator approach (excluding variance) will be decreased
# TOTAL TIME FOR A SINGLE LOOP: timeAwayFromNest + timeUntilHeadToNest + LandingTime + StayLength
# Future feature: Predator could respond to noise

func predatorLoop():
	while 1 == 1:
		timeAwayFromNest = BASE_TIME_AWAY_FROM_NEST - aggressionTimeDecrease - randi_range(0, TIME_AWAY_VARIANCE)
		$ProgressBar.max_value = timeAwayFromNest
		while timeAwayFromNest >= 0 or momIsHome:
			await $Timer.timeout
			timeAwayFromNest -= 1
			$ProgressBar.value = $ProgressBar.max_value - timeAwayFromNest
			if timeAwayFromNest == 0 and momIsHome:
				print("Predator: momma bird preventing approach to nest")
				timeAwayFromNest = TIME_AWAY_STALL
		# Predator approaches the nest
		emit_signal("toggle_predator_approach")
		print("Predator: Approaches nest")
		timeUntilHeadToNest = randi_range(TIME_APPROACHED_MIN, TIME_APPROACHED_MAX)
		while timeUntilHeadToNest >= 0 or momIsHome:
			await $Timer.timeout
			if momIsHome:
				print("Predator: momma bird preventing head to nest")
				timeUntilHeadToNest = TIME_APPROACHED_STALL
			else:
				timeUntilHeadToNest -= 1
		print("Predator: Heads to nest")
		headToNest()
		while (predIsHome):
			await $Timer.timeout
		emit_signal("predator_leaves_nest")
		aggressionTimeDecrease += (BASE_TIME_AWAY_FROM_NEST - aggressionTimeDecrease) / 9.0 # This will shorten the time until the next predator approach
		print("Predator: Leaves nest")

func birdDetectorCircleAnimation():
	$bird_detector/Sprite2D.visible = true
	$bird_detector/Sprite2D.modulate.a = 1
	var i = 40
	while i > 0:
		$bird_detector/Sprite2D.modulate.a -= .02
		await get_tree().create_timer(0.04).timeout
		i -= 1
	$bird_detector/Sprite2D.visible = false

func evaluateObject(object):
	if object.is_in_group("dumb"):
		foundDumbBird = true
		target = object
	else: if object.is_in_group("player") and !foundDumbBird:
		foundPlayerBird = true
		target = object
	else: if object.is_in_group("bird") and !foundDumbBird and !foundPlayerBird:
		foundBird = true
		target = object
		
func predatorEatDecision(): # Signal output / functions handling actually eating the birds will go here
	if foundDumbBird:
		print("Predator wants to eat the dumb bird")
	else: if foundPlayerBird:
		print("Predator wants to eat the player")
		emit_signal("player_eaten")
	else: if foundBird:
		print("Predator wants to eat the ai bird")
	else:
		print("Predator doesn't notice any birds")
	emit_signal("bird_eaten", target)

func headToNest():
	predIsHome = true # Prevents predator loop from continuing
	emit_signal("toggle_predator_presence") # Sent to other nodes, makes rig visible
	await get_tree().create_timer(LandingTime).timeout
	birdDetectorCircleAnimation() # Indicates to player what area isn't safe
	emit_signal("pred_position", $bird_detector/Sprite2D.position) #sends pixel position to RUN AWAY FROM
	#CHANGE THIS VALUE TO INCREASE PREDATOR MOVEMENTS
	# Booleans that are used in predatorEatDecision()
	foundBird = false
	foundPlayerBird = false
	foundDumbBird = false
	await get_tree().create_timer(StayLength).timeout
	for object in $bird_detector.get_overlapping_areas(): # Grabs all birds in detection range, evaluates them
		evaluateObject(object)
	predatorEatDecision() # Given previous booleans, figure out which bird to eat, if any
	emit_signal("toggle_predator_presence")
	predIsHome = false
	
func _on_process_momma_bird_toggle_mom_presence():
	momIsHome = !momIsHome
