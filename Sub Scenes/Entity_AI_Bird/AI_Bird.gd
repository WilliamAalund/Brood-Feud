extends Node2D

const STARTING_LEVEL = 0
const EXP_TO_LEVEL_UP = 3
const LEVEL_UP_PUSH_FORCE_INCREASE = 400
const LEVEL_UP_SCALE_INCREASE = 0.1
const LEVEL_UP_MOVE_SPEED_INCREASE = 10
const BLEED_RATE = 0.04

@export var satiation = 100
@export var starvationThreshold = 30 # Currently unused, doesn't have a good place in the state logic right now
@export var lowerAngryThreshold = 50
@export var upperAngryThreshold = 150

var level = 1
var exp = 0
var damage = 0

# State variable is in the child CharacterBody2D Node
# TODO: Implement momHome, and isStupid

# --- VALUES USED IN STATE CALCULATIONS
var aggroVal = 0 # Bird begins with no aggro value
var aggroTarget
var sunspotTarget
var numSunlightSpotsInside = 0
var numSunlightSpotsNoticed = 0
var numFoodsNoticed = 0

# --- BOOLEANS USED IN STATE CALCULATIONS
var debug = false
var noticedFood = false
var noticedSunray = false
var noticedPredator = false
var noticedMom = false
var isStupid = false
var inSunlight = false
var isDead = false

func _ready(): # Will be removed later on when the bird should actually start in the nest
	$CharacterBody2D.state = updatedState()
	#$CharacterBody2D/Debug_Satiation_Label.text = "DG"
	if isStupid:
		$CharacterBody2D/body_zone.add_to_group("dumb")
	

func eat(): # Function called to increase satiation when you eat.
	if satiation + get_parent().foodRestore > 100:
		satiation = 100
	else:
		satiation += get_parent().foodRestore
	exp += 1
	if exp >= EXP_TO_LEVEL_UP:
		print("AI BIRD LEVELED UP")
		levelUp()

func expend(value): # Immedeately decreases satiation by a specified amount.
	if satiation - value < 0:
		satiation = 0
		isDead = true
		$CharacterBody2D/eater_zone.remove_from_group("eater")
		$CharacterBody2D/Sprite2D.modulate = Color(.5,.3,.3,1) # Indicate to the player that the bird is dead
	else:
		satiation -= value

func levelUp():
	level += 1
	exp = 0
	#self.scale += Vector2(LEVEL_UP_SCALE_INCREASE,LEVEL_UP_SCALE_INCREASE)
	$CharacterBody2D.push_force += LEVEL_UP_PUSH_FORCE_INCREASE
	$CharacterBody2D.speed += LEVEL_UP_MOVE_SPEED_INCREASE
	$CharacterBody2D.modulate = Color(.5,1,.5,1)
	var i = 0.0
	while i < 5:
		$CharacterBody2D.modulate = Color(.5 + (i / 10),1,.5 + (i / 10),1)
		self.scale += Vector2(LEVEL_UP_SCALE_INCREASE / 5,LEVEL_UP_SCALE_INCREASE / 5)
		await get_tree().create_timer(0.1).timeout
		i += 1
	$CharacterBody2D.modulate = Color(1,1,1,1)

func bleed(value):
	damage += value
	var totalDamageIncurred = damage * BLEED_RATE
	Input.start_joy_vibration(.5, 1, 0, totalDamageIncurred / 4)
	print("Queued damage: ", totalDamageIncurred)

# -- STATE DESCRIPTIONS --
# 1 - Idle
# 2 - Focused on food
# 3 - Focused on player/other bird. Focus dictated by aggroTarget
# 4 - Focused on moving to sunspot
# 5 - Focused on hiding from predator
# 6 - Dead
# 7 - Debug
# 8 - Unallocated

func updatedState(): # Returns variable corresponding to state. state then used in pathfinding.
	if debug: # If the bird is in a debugger state, then it will only run the debugging code
		return 7
	else: if isDead: # If the bird is dead its dead, won't do anything.
		return 6 # Dead
	else: if aggroVal >= upperAngryThreshold: # If you are consistently attacking a bird, it will prioritize attacking you
		return 3
	else: if noticedPredator and not isStupid: # The next thing that will take over is fight or flight. If the bird is scared or angry it will prioritize that. Unless it is a stupid bird.
		return 5
	else: if aggroVal >= lowerAngryThreshold: # If the bird isn't starving, it will respond to aggression from the player, as well as from other birds.
		return 3
	else: if noticedMom or noticedFood: # If the bird isn't dead, if there is no predator, if the bird isnt angry, and mom is home or the bird is starving, it will look for food.
		return 2
	else: if noticedSunray: # If all of the other conditions aren't met, and the bird sees a sunspot, then it will seek out the sunspot.
		return 4
	else: # If the bird isn't dead, there is no predator, it isn't angry, it is not starving, mom isn't home, and there is no sunspot to seek out, then the bird will remain idle.
		return 1 # Idle

func _on_bird_control_ai_bird_move(target_position):
	$CharacterBody2D.target = target_position # Replace with function body.

func _on_timer_timeout():
	$CharacterBody2D.state = updatedState()
	$CharacterBody2D/Debug_AI_State.text = str($CharacterBody2D.state) + " " + str(numSunlightSpotsInside)

	$CharacterBody2D/boolean_tag.text = str(numSunlightSpotsNoticed) + " " + str(noticedSunray)
	if aggroVal > 0:
		aggroVal -= 1
	#print("AI bird  : state updated to: " + str($CharacterBody2D.state))

func _on_bird_control_birds_increment_hunger():
	satiation -= get_parent().idleSatiationDrainRate + get_parent().sunRate * int(inSunlight) + BLEED_RATE * int(bool(damage))
	$CharacterBody2D/Debug_Satiation_Label.text = str(satiation).substr(0,5)
	if satiation <= 0: # Prevent dead bodies from eating food
		isDead = true
		$CharacterBody2D/eater_zone.remove_from_group("eater")
		$CharacterBody2D/Sprite2D.modulate = Color(.5,.3,.3,1) # Indicate to the player that the bird is dead
	if damage > 0:
		damage -= 1

func _on_body_zone_area_entered(area):
	if area.is_in_group("sunray"):
		numSunlightSpotsInside += 1
		await get_tree().create_timer(1.0).timeout # I don't know why I put this here, but I don't want to remove it just in case it is important
		inSunlight = true
	else: if area.is_in_group("attacker"):
		print("attacked")
		aggroVal += 100
		bleed(45)

func _on_body_zone_area_exited(area):
	if area.is_in_group("sunray"):
		numSunlightSpotsInside -= 1
		if numSunlightSpotsInside <= 1:
			inSunlight = false

func _on_detector_zone_area_entered(area):
	if area.is_in_group("sunray"):
		numSunlightSpotsNoticed += 1
		noticedSunray = true
	else: if area.is_in_group("food"):
		numFoodsNoticed += 1
		noticedFood = true

func _on_detector_zone_area_exited(area):
	if area.is_in_group("sunray"):
		numSunlightSpotsNoticed -= 1
		if numSunlightSpotsNoticed <= 0:
			numSunlightSpotsNoticed = 0
			noticedSunray = false
			print("No more sunrays to notice")
	else: if area.is_in_group("food"):
		numFoodsNoticed -= 1
		if numFoodsNoticed <= 0:
			numFoodsNoticed = 0
			noticedFood = false

func _on_bird_control_birds_toggle_predator_notice():
	noticedPredator = !noticedPredator

func _on_bird_control_birds_toggle_momma_bird_notice():
	noticedMom = !noticedMom

func _on_eater_zone_area_entered(area): # When the bird is interacting, and its beak collides with an area
	if area.is_in_group("food"):
		eat()

func _on_eater_detector_zone_area_entered(area): # When the bird detects that its beak could hit something
	if area.is_in_group("food"):
		$CharacterBody2D.beakInteract()
	elif area.is_in_group("player") and aggroVal > lowerAngryThreshold:
		$CharacterBody2D.beakInteract()
