extends Node2D

@export var LandingTime = 0.5

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
	
func _physics_process(_delta): # If the predator is in the nest, scan any bird object in the detector zone, and flip booleans for detection depending on the type of bird
	if predIsHome:
		analyzeBirdsInPredatorSightZone()
		
func printDebugLabels():
#	$bird_booleans.text = foundDumbBird + "\n" + foundBird + "\n" + foundPlayerBird
	print("Dumb fird found?   ", foundDumbBird)
	print("Bird found?        ", foundBird)
	print("Player bird found? ", foundPlayerBird)

# --- PREDATOR LOOP ---
# Always running in the background
# Predator initially waits the base time to be away from the nest (minus a potential variance value)
# Time is measures in seconds.
# Once this time is up, the predator will attempt to "approach" the nest. If momma bird is home, the predator will not approach
# The predator will then spend between 2 to 5 seconds "approached" before actually heading to the nest. The predator will not approach if they were blocked by momma bird
# Then the predator will head to the nest, and run the script handing that event.
# After the predator leaves the nest, the time until the next predator approach (excluding variance) will be decreased
# TOTAL TIME FOR A SINGLE LOOP: timeAwayFromNest + timeUntilHeadToNest + LandingTime + TIME_TO_STAY_AT_NEST
# Future feature: Predator could respond to noise

func predatorLoop():
	while 1 == 1:
		timeAwayFromNest = max(Game_Parameters.BASE_TIME_AWAY_FROM_NEST - aggressionTimeDecrease - randi_range(0, Game_Parameters.TIME_AWAY_VARIANCE), 15) # Time away from nest will always be at least 15 seconds
		$ProgressBar.max_value = timeAwayFromNest
		while timeAwayFromNest >= 0 or momIsHome:
			await $Timer.timeout
			timeAwayFromNest -= 1
			$ProgressBar.value = $ProgressBar.max_value - timeAwayFromNest
			if timeAwayFromNest == 0 and momIsHome:
				print("Predator: momma bird preventing approach to nest")
				timeAwayFromNest = Game_Parameters.TIME_AWAY_STALL
				if Game_Parameters.gameOccurring:
					$merlin_distance.play()
		# Predator approaches the nest
		emit_signal("toggle_predator_approach")
		print("Predator: Approaches nest")
		timeUntilHeadToNest = randi_range(Game_Parameters.TIME_APPROACHED_MIN, Game_Parameters.TIME_APPROACHED_MAX)
		if Game_Parameters.gameOccurring:
			$merlin_distance.play()
		
		while timeUntilHeadToNest >= 0 or momIsHome:
			await $Timer.timeout
			if momIsHome:
				print("Predator: momma bird preventing head to nest")
				timeUntilHeadToNest = Game_Parameters.TIME_APPROACHED_STALL
			else:
				timeUntilHeadToNest -= 1
		print("Predator: Heads to nest")
		headToNest()
		while (predIsHome):
			await $Timer.timeout
		emit_signal("predator_leaves_nest")
		if Game_Parameters.BASE_TIME_AWAY_FROM_NEST - aggressionTimeDecrease > 15:
			aggressionTimeDecrease += (Game_Parameters.BASE_TIME_AWAY_FROM_NEST - aggressionTimeDecrease) / 9.0 # This will shorten the time until the next predator approach
		print("Predator: Leaves nest")
		if Game_Parameters.gameOccurring:
			$merlin_fly_out.play()

func birdDetectorCircleAnimation():
	$bird_detector/Sprite2D.visible = true
	$bird_detector/Sprite2D.modulate.a = 1
	var i = 40
	while i > 0:
		$bird_detector/Sprite2D.modulate.a -= .02
		await get_tree().create_timer(0.04).timeout
		i -= 1
	$bird_detector/Sprite2D.visible = false

func analyzeBirdsInPredatorSightZone():
	for object in $bird_detector.get_overlapping_areas(): # Grabs all birds in detection range, evaluates them
		evaluateObject(object)

func evaluateObject(object):
	if object.is_in_group("dumb") and not object.is_in_group("carcus"):
		foundDumbBird = true
		target = object
	else: if object.is_in_group("player") and not object.is_in_group("carcus") and not foundDumbBird:
		foundPlayerBird = true
		target = object
	else: if object.is_in_group("bird") and not object.is_in_group("carcus") and not foundDumbBird and not foundPlayerBird:
		foundBird = true
		target = object

func resetDetectionBooleans(): # Called when predator begins to scan the nest
	foundDumbBird = false
	foundBird = false
	foundPlayerBird = false

func predatorEatDecision(): # Signal output / functions handling actually eating the birds will go here
	printDebugLabels()
	if foundDumbBird:
		print("Predator wants to eat the dumb bird")
		emit_signal("bird_eaten", target)
	else: if foundPlayerBird:
		print("Predator wants to eat the player")
		emit_signal("player_eaten")
	else: if foundBird:
		print("Predator wants to eat the ai bird")
		emit_signal("bird_eaten", target)
	else:
		print("Predator doesn't notice any birds")

func headToNest():
	predIsHome = true # Prevents predator loop from continuing
	emit_signal("toggle_predator_presence") # Sent to other nodes, makes rig visible
	fadeOutAudio(1.0)
	if Game_Parameters.gameOccurring:
		$merlin_close.play()
		$merlin_fly_in.play()
	await get_tree().create_timer(LandingTime).timeout
	resetDetectionBooleans() # Booleans that are used in predatorEatDecision()
	birdDetectorCircleAnimation() # Indicates to player what area isn't safe
	emit_signal("pred_position", $bird_detector/Sprite2D.position) #sends pixel position to RUN AWAY FROM
	await get_tree().create_timer(Game_Parameters.TIME_TO_STAY_AT_NEST).timeout
	predatorEatDecision() # Given previous booleans, figure out which bird to eat, if any
	emit_signal("toggle_predator_presence")
	predIsHome = false
	
func _on_process_momma_bird_toggle_mom_presence():
	momIsHome = !momIsHome
	
func fadeOutAudio(duration: float):
	var initialVolume = $merlin_distance.volume_db
	var targetVolume = -80.0  # Adjust this value based on the desired minimum volume
	
	while $merlin_distance.volume_db > targetVolume:
		$merlin_distance.volume_db -= (initialVolume / duration) * get_process_delta_time()
		await(get_tree().create_timer(0.0, false).timeout)
		
	$merlin_distance.stop()

