extends Node2D

const STARTING_LEVEL = 0
const EXPERIENCE_TO_LEVEL_UP = 3
const LEVEL_UP_PUSH_FORCE_INCREASE = 400
const LEVEL_UP_SCALE_INCREASE = 0.1
const LEVEL_UP_MOVE_SPEED_INCREASE = 10
const BLEED_RATE = 0.04
const MAXIMUM_FOOD_IN_TUMMY_ALLOWED = 2

@export var satiation = 100
@export var starvationThreshold = 30 # Currently unused, doesn't have a good place in the state logic right now
@export var lowerAngryThreshold = 50
@export var upperAngryThreshold = 150

var age = 1
var experience = 0
var damage = 0
var sizeExperience = 0

# State variable is in the child CharacterBody2D Node
# TODO: Implement momHome, and isStupid
# --- ARRAYS USED IN STATE CALCULATIONS
var foodTargetsArray = []
var sunrayTargetsArray = []


# --- VALUES USED IN STATE CALCULATIONS
var aggroVal = 0 # Bird begins with no aggro value
var aggroTarget
var sunspotTarget
var numSunlightSpotsInside = 0
var numSunlightSpotsNoticed = 0
var numFoodsNoticed = 0
var foodInTummy = 0 # Prevents overeating
var stunVal = 0

# --- BOOLEANS USED IN STATE CALCULATIONS
var debug = false
var noticedFood = false
var noticedSunray = false
var noticedPredator = false
var noticedMom = false
var isStupid = false
var inSunlight = false
var isDead = false

var predator_spot = Vector2(0,0) #(0,0) is null, and means birds don't know where pred is. sets when
#predator shows itself

func _ready(): # Will be removed later on when the bird should actually start in the nest
	updateTargetArraysAndClosestPositions()
	$CharacterBody2D.state = updatedState()
	if isStupid:
		makeBirdStupid()

func makeBirdStupid(): # Called by bird manager to make one bird stupid
	isStupid = true
	$CharacterBody2D/body_zone.add_to_group("dumb")
	print("An AI bird is now stupid.")
	
func _physics_process(_delta):
	updateTargetArraysAndClosestPositions()
	updateDecisionBooleans()
	if sizeExperience > 0:
		self.scale += Vector2(LEVEL_UP_SCALE_INCREASE / 20,LEVEL_UP_SCALE_INCREASE / 20)
		$CharacterBody2D.modulate = Color(.5 + (sizeExperience / 20.0),1,.5 + (sizeExperience / 20.0),1)
		sizeExperience -= 1
		if sizeExperience <= 0:
			$CharacterBody2D.modulate = Color(1,1,1,1)
	if stunVal > 0:
		stunVal -= 1
	

func eat(): # Function called to increase satiation when you eat.
	foodInTummy += 1
	if satiation + get_parent().foodRestore > 100:
		satiation = 100
	else:
		satiation += get_parent().foodRestore
	experience += 1
	if experience >= EXPERIENCE_TO_LEVEL_UP:
		ageUp()

func expend(value): # Immedeately decreases satiation by a specified amount.
	if satiation - value < 0:
		satiation = 0
		print("starved 1")
		killBird()
	else:
		satiation -= value

func ageUp():
	age += 1
	experience = 0
	#self.scale += Vector2(LEVEL_UP_SCALE_INCREASE,LEVEL_UP_SCALE_INCREASE)
	$CharacterBody2D.push_force += LEVEL_UP_PUSH_FORCE_INCREASE
	$CharacterBody2D.speed += LEVEL_UP_MOVE_SPEED_INCREASE
	$CharacterBody2D.modulate = Color(.5,1,.5,1)
	sizeExperience += 20

func bleed(value):
	damage += value
	#var totalDamageIncurred = damage * BLEED_RATE
	Input.start_joy_vibration(.5, 1, 0, 0.2)
	stunVal += 15
	#print("Queued damage: ", totalDamageIncurred)

func killBird():
	isDead = true
	$CharacterBody2D/eater_zone.remove_from_group("eater")
	$CharacterBody2D/Sprite2D.visible = false
	$CharacterBody2D/dead_bird_sprite.visible = true # Indicate to the player that the bird is dead
	$CharacterBody2D/dead_bird_sprite.modulate = Color(.5,.3,.3,1)
	$CharacterBody2D/body_zone.remove_from_group("dumb")
	if $CharacterBody2D/CollisionShape2D:
		$CharacterBody2D/CollisionShape2D.queue_free()
	self.z_index = 0

# -- STATE DESCRIPTIONS --
# 1 - Idle
# 2 - Focused on food
# 3 - Focused on player/other bird. Focus dictated by aggroTarget
# 4 - Focused on moving to sunspot
# 5 - Focused on hiding from predator
# 6 - Dead
# 7 - Debug
# 8 - Stunned

func updatedState(): # Returns variable corresponding to state. state then used in pathfinding.
	if debug: # If the bird is in a debugger state, then it will only run the debugging code
		return 7
	else: if isDead: # If the bird is dead its dead, won't do anything.
		return 6 # Dead
	else: if stunVal > 0 and aggroVal <= upperAngryThreshold:
		return 8
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

func updateTargetArraysAndClosestPositions():
	foodTargetsArray = []
	sunrayTargetsArray = []
	for area in $CharacterBody2D/detector_zone.get_overlapping_areas():
		if area.is_in_group("food"):
			foodTargetsArray.append(area.global_position)
		else: if area.is_in_group("sunray"):
			sunrayTargetsArray.append(area.global_position)
		else: if area.is_in_group("player"):
			$CharacterBody2D.playerTarget = area.global_position
			#playerTarget = area.global_position
	if foodTargetsArray.size() > 0:
		$CharacterBody2D.foodTarget = findClosestTarget(foodTargetsArray)
	if sunrayTargetsArray.size() > 0:
		$CharacterBody2D.sunrayTarget = findClosestTarget(sunrayTargetsArray)

func findClosestTarget(array):
	if array.size() == 0:
		print("Error: array contains no values")
		return self.position
	var closestPosition = array[0]
	for item in array:
		if (self.position).length() - item.length() < closestPosition.length():
			#index = item.index
			closestPosition = item
	return closestPosition

func updateDecisionBooleans():
	if foodTargetsArray.size() > 0 and foodInTummy < MAXIMUM_FOOD_IN_TUMMY_ALLOWED:
		noticedFood = true
	else:
		noticedFood = false
	if sunrayTargetsArray.size() > 0:
		noticedSunray = true
	else:
		noticedSunray = false

func _on_bird_control_ai_bird_move(target_position):
	$CharacterBody2D.target = target_position # Replace with function body.

func _on_timer_timeout():
	$CharacterBody2D.state = updatedState()
	$CharacterBody2D/Debug_AI_State.text = str($CharacterBody2D.state)

	$CharacterBody2D/boolean_tag.text = str(foodInTummy)
	if aggroVal > 0:
		aggroVal -= 1
	#print("AI bird  : state updated to: " + str($CharacterBody2D.state))

func _on_bird_control_birds_increment_hunger():
	satiation -= get_parent().idleSatiationDrainRate + get_parent().sunRate * int(inSunlight) + BLEED_RATE * int(bool(damage))
	$CharacterBody2D/Debug_Satiation_Label.text = str(satiation).substr(0,5)
	if satiation <= 0: # Prevent dead bodies from eating food
		print("starved")
		isDead = true
		killBird()
	if damage > 0:
		damage -= 1

func _on_body_zone_area_entered(area):
	if area.is_in_group("sunray"):
		numSunlightSpotsInside += 1
		await get_tree().create_timer(1.0).timeout # I don't know why I put this here, but I don't want to remove it just in case it is important
		if numSunlightSpotsInside > 0:
			inSunlight = true
	else: if area.is_in_group("attacker"):
		aggroVal += 100
		bleed(45)

func _on_body_zone_area_exited(area):
	if area.is_in_group("sunray"):
		numSunlightSpotsInside -= 1
		if numSunlightSpotsInside <= 0:
			inSunlight = false

func _on_bird_control_birds_toggle_predator_notice():
	noticedPredator = !noticedPredator
	$CharacterBody2D.predator_place = Vector2(0,0) #resets to null
	


func _on_bird_control_birds_toggle_momma_bird_notice():
	noticedMom = !noticedMom
	foodInTummy = 0

func _on_eater_zone_area_entered(area): # When the bird is interacting, and its beak collides with an area
	if area.is_in_group("food") and foodInTummy < MAXIMUM_FOOD_IN_TUMMY_ALLOWED:
		eat()

func _on_eater_detector_zone_area_entered(area): # When the bird detects that its beak could hit something
	if satiation > 0:
		if area.is_in_group("food"):
			$CharacterBody2D.beakInteract()
		elif area.is_in_group("player") and aggroVal > lowerAngryThreshold:
			$CharacterBody2D.beakInteract()


func _on_bird_control_pred_spot(spot):
	predator_spot = spot
	$CharacterBody2D.predator_place = spot


func _on_bird_control_kill(bird):
	print("kill switch recieved")
	if(bird == $CharacterBody2D/body_zone):
		print("bleh")
		killBird()
	print("I'm alive!!")




