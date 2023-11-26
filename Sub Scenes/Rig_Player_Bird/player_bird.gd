extends Node2D

@export var hasInfiniteFood = false

var level = 1
var experience = 0
var satiation = 100
var damage = 0
var numSunlightSpotsInside = 0
var inSunlight = false
var stomachCapacity # Value set in _ready() function
var foodInStomach = 1
var momIsHome = false

signal player_starved
signal player_attacked
signal player_grew_up

func _ready():
	stomachCapacity = Game_Parameters.BASE_STOMACH_CAPACITY
	updateDebuggerLabel()

func _process(_delta):
	updateDebuggerLabel()

func updateDebuggerLabel():
	$bird_body/debugger_label.text = "l:" + str(level)
	$bird_body/debugger_label.text += " s:" + str(satiation).substr(0,5)
	$bird_body/debugger_label.text += " d:" + str(damage)

func eat(): # Function called to increase satiation when you eat.
	if satiation + Game_Parameters.FOOD_RESTORE > 100:
		satiation = 100
	else:
		satiation += Game_Parameters.FOOD_RESTORE
	Input.start_joy_vibration(0, 1, 0, 0.15)
	print("Vibration: RigPlayerBirdplayerbird2")
	foodInStomach += 1
	if foodInStomach >= stomachCapacity:
		$bird_body.isFull = true # If true, bird beak cannot eat any food, as it will not be in the "eater" group
	else:
		$bird_body.isFull = false
	experience += 1
	if experience >= Game_Parameters.PLAYER_EXPERIENCE_TO_LEVEL_UP:
		ageUp()

func ageUp():
	level += 1 # Level up
	experience = 0 # Reset experience
	if level % 2 == 0 and stomachCapacity < Game_Parameters.MAXIMUM_STOMACH_CAPACITY:
		stomachCapacity += 1
	$bird_body.ageUpBody()
	if level >= Game_Parameters.LEVEL_NEEDED_TO_WIN_THE_GAME:
		emit_signal("player_grew_up")

func expend(value): # Immedeately decreases satiation by a specified amount.
	if satiation - value < 0:
		satiation = 0
	else:
		satiation -= value

func increaseDamageAmount(value): # for each 1 of damage, satiation will be decrease at an increased rate of BLEED_RATE
	damage += value
	var totalDamageIncurred = damage * Game_Parameters.PLAYER_BIRD_BLEED_RATE
	Input.start_joy_vibration(.5, 1, 0, 0.2)
	print("Vibration: RigPlayerBirdplayerbird")
	print("Queued damage: ", totalDamageIncurred)

func decrementSatiation(): # Decreases the bird's satiation value
	if hasInfiniteFood:
		pass
	else:
		satiation -= (Game_Parameters.IDLE_SATIATION_DRAIN_RATE - 0.02) + (level / 100.0) + Game_Parameters.SUN_RATE * int(inSunlight) + Game_Parameters.PLAYER_BIRD_BLEED_RATE * int(bool(damage))
		if satiation < 0:
			emit_signal("player_starved")
		if damage > 0:
			damage -= 1

# --- SIGNAL DETECTION ---

func _on_bird_body_area_area_exited(area): # Detect when the bird leaves sunlight
	if area.is_in_group("sunray"):
		numSunlightSpotsInside -= 1
		inSunlight = bool(numSunlightSpotsInside)

func _on_bird_body_area_area_entered(area): # Detect when the body enters sunlight, or is attacked
	if area.is_in_group("sunray"):
		numSunlightSpotsInside += 1
		inSunlight = bool(numSunlightSpotsInside)

	elif area.is_in_group("ai_attacker"):
		print("Player attacked")
		emit_signal("player_attacked")
		increaseDamageAmount(45)

func _on_bird_head_area_entered(area): # Detect beak area entered
	if area.is_in_group("food") and !$bird_body.isFull:
		eat()

func _on_bird_body_player_attacks(): # Detect when the player attacks
	expend(0)

func _on_bird_control_birds_increment_hunger(): # Detect bird control telling bird to increment hunger
	decrementSatiation()

func _on_bird_control_birds_toggle_momma_bird_notice():
	momIsHome = !momIsHome
	if momIsHome:
		foodInStomach = 0
		$bird_body.isFull = false
