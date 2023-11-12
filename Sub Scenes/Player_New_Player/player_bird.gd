extends Node2D

const STARTING_LEVEL = 0
const EXP_TO_LEVEL_UP = 4
const LEVEL_UP_PUSH_FORCE_INCREASE = 400
const LEVEL_UP_SCALE_INCREASE = 0.1
const LEVEL_UP_MOVE_SPEED_INCREASE = 10
const BLEED_RATE = 0.04

@export var hasInfiniteFood = true

var level = 1
var exp = 0
var satiation = 100
var damage = 0
var numSunlightSpotsInside = 0
var inSunlight = false

signal playerStarved

func _ready():
	$character_bird/debugger_satiation.text = str(satiation).substr(0,5)

func eat(): # Function called to increase satiation when you eat.
	if "foodRestore" in get_parent():
		if satiation + get_parent().foodRestore > 100:
			satiation = 100
		else:
			satiation += get_parent().foodRestore
		Input.start_joy_vibration(0, 1, 0, 0.15)
	exp += 1
	if exp == EXP_TO_LEVEL_UP:
		levelUp()
		
func levelUp():
	level += 1
	exp = 0
	#self.scale += Vector2(LEVEL_UP_SCALE_INCREASE,LEVEL_UP_SCALE_INCREASE)
	$character_bird.push_force += LEVEL_UP_PUSH_FORCE_INCREASE
	$character_bird.move_speed += LEVEL_UP_MOVE_SPEED_INCREASE
	$character_bird.modulate = Color(.5,1,.5,1)
	var i = 0.0
	while i < 5:
		$character_bird.modulate = Color(.5 + (i / 10),1,.5 + (i / 10),1)
		self.scale += Vector2(LEVEL_UP_SCALE_INCREASE / 5,LEVEL_UP_SCALE_INCREASE / 5)
		await get_tree().create_timer(0.1).timeout
		i += 1
	$character_bird.modulate = Color(1,1,1,1)

func expend(value): # Immedeately decreases satiation by a specified amount.
	if satiation - value < 0:
		satiation = 0
		emit_signal("playerStarved")
	else:
		satiation -= value

func bleed(value):
	damage += value
	var totalDamageIncurred = damage * BLEED_RATE
	Input.start_joy_vibration(.5, 1, 0, totalDamageIncurred / 4)
	print("Queued damage: ", totalDamageIncurred)

func decrementSatiation(): # Decreases the bird's satiation value
	if hasInfiniteFood:
		satiation = 100
	else:
		satiation = satiation - get_parent().idleSatiationDrainRate - get_parent().sunRate * int(inSunlight) - BLEED_RATE * int(bool(damage))
		$character_bird/debugger_satiation.text = str(satiation).substr(0,5)
		if satiation < 0:
			emit_signal("playerStarved")
		if damage > 0:
			damage -= 1
# --- DETECTING EATING, DECREMENTING HUNGER ---
func _on_beak_area_area_entered(area):
	if area.is_in_group("food"):
		eat()

func _on_bird_control_birds_increment_hunger():
	decrementSatiation()

# --- ENTERING, EXITING SUNLIGHT ---
func _on_body_area_area_entered(area):
	if area.is_in_group("sunray"):
		numSunlightSpotsInside += 1
		inSunlight = bool(numSunlightSpotsInside)
	elif area.is_in_group("ai_attacker"):
		print("Player attacked")
		bleed(45)

func _on_body_area_area_exited(area):
	if area.is_in_group("sunray"):
		numSunlightSpotsInside -= 1
		inSunlight = bool(numSunlightSpotsInside)

func _on_character_bird_player_attacks():
	expend(2)
