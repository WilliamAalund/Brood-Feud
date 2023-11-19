extends Node2D

const STARTING_LEVEL = 0
const EXP_TO_LEVEL_UP = 4
const LEVEL_UP_PUSH_FORCE_INCREASE = 400
const LEVEL_UP_SCALE_INCREASE = 0.2
const LEVEL_UP_MOVE_SPEED_INCREASE = 10
const LEVEL_NEEDED_TO_CHANGE_SPRITE = 6
const LEVEL_NEEDED_TO_WIN_THE_GAME = 1
const BLEED_RATE = 0.03

@export var hasInfiniteFood = false

var level = 1
var experience = 0
var satiation = 100
var damage = 0
var numSunlightSpotsInside = 0
var inSunlight = false

signal player_starved
signal player_attacked
signal player_grew_up

func _ready():
	updateDebuggerLabel()

func _process(delta):
	updateDebuggerLabel()

func updateDebuggerLabel():
	$bird_body/debugger_label.text = "l:" + str(level)
	$bird_body/debugger_label.text += " s:" + str(satiation).substr(0,5)
	$bird_body/debugger_label.text += " d:" + str(damage)

func eat(): # Function called to increase satiation when you eat.
	if "foodRestore" in get_parent():
		if satiation + get_parent().foodRestore > 100:
			satiation = 100
		else:
			satiation += get_parent().foodRestore
		Input.start_joy_vibration(0, 1, 0, 0.15)
		print("Vibration: RigPlayerBirdplayerbird2")
	experience += 1
	if experience >= EXP_TO_LEVEL_UP:
		levelUp()
		
func levelUp():
	level += 1 # Level up
	experience = 0 # Reset experience
	$bird_body.ageUpBody()
	if level >= LEVEL_NEEDED_TO_WIN_THE_GAME:
		emit_signal("player_grew_up")

func expend(value): # Immedeately decreases satiation by a specified amount.
	if satiation - value < 0:
		satiation = 0
	else:
		satiation -= value

func increaseDamageAmount(value): # for each 1 of damage, satiation will be decrease at an increased rate of BLEED_RATE
	damage += value
	var totalDamageIncurred = damage * BLEED_RATE
	Input.start_joy_vibration(.5, 1, 0, 0.2)
	print("Vibration: RigPlayerBirdplayerbird")
	print("Queued damage: ", totalDamageIncurred)
	
func decrementSatiation(): # Decreases the bird's satiation value
	if hasInfiniteFood:
		pass
	else:
		satiation -= (get_parent().idleSatiationDrainRate - 0.02) + (level / 100.0) + get_parent().sunRate * int(inSunlight) + BLEED_RATE * int(bool(damage))
		if satiation < 0:
			emit_signal("player_starved")
		if damage > 0:
			damage -= 1
			
			
# ---------- SIGNAL DETECTION ----------

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
	if area.is_in_group("food"):
		eat()

func _on_bird_body_player_attacks(): # Detect when the player attacks
	expend(1)

func _on_bird_control_birds_increment_hunger(): # Detect bird control telling bird to increment hunger
	decrementSatiation()
