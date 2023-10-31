extends Node2D

# Rate incrementing to 100 in the background

# there is a ratevalue% chance that predator will head to the nest.
# If the predator heads to the nest, there is a 10% chance they will go to the nest every check
# And a 10% chance to leave the nest the next time a role occurs
# If the predator comes to the nest, momma bird cannot return. 
# If you are moving, the bird eats you.
# If you are near the middle of the nest, the bird eats you.
# Future features: the chance the predator comes to the nest will increase depending on noise.


@export var MaxPredAggro = 750
@export var PredAggroIncrement = 1
@export var LandingTime = 0.5
@export var StayLength = 5

var predAggro = 0
var predApproached = false
var isHome = false
var momIsHome = false

signal toggle_predator_presence # Indicates to other nodes that the predator is at the nest.

func _ready(): # Momma bird starts off invisible
	var predSprite = get_child(0)
	predSprite.visible = isHome
	$ProgressBar.max_value = MaxPredAggro

func approachCheck() -> bool:
	var check = randi_range(predAggro, MaxPredAggro)
	$Debug_Roll.text = str(check)
	#print("Predator : Approach check: ", check)
	if check == MaxPredAggro:
		return true
	else:
		#print("false")
		return false

func headCheck() -> bool:
	if momIsHome:
		print("Predator : cannot head to nest: momma bird is watching")
		return false
	return randi_range(1, 100) > 40 and !momIsHome

func _on_timer_timeout(): # State machine(?) Every time a second passes, 
	if !isHome:
		predAggro += PredAggroIncrement # Slightly increments predAggro
		if predAggro > MaxPredAggro:
			predAggro = MaxPredAggro
		#print(predAggro, predAggro / MaxPredAggro)
		$ProgressBar.value = predAggro
	if predAggro % 10 == 0 and !isHome:
		if predApproached:
			if headCheck():
				print("Predator : heads to nest")
				isHome = true
				# Run evil predator functions
				headToNest()
			else: if momIsHome:
				pass # Preserves aggression level. Bird will not completely reset: just wait for another chance
		else: if approachCheck():
			print("Predator : approaches nest")
			predApproached = true
			
			
			
func headToNest():
	emit_signal("toggle_predator_presence")
	await get_tree().create_timer(LandingTime).timeout
	var predSprite = get_child(0)
	predSprite.visible = isHome
	await get_tree().create_timer(StayLength).timeout
	print("Predator : leaves nest")
	isHome = false
	predSprite.visible = isHome
	predApproached = false
	predAggro = 0
	emit_signal("toggle_predator_presence")
	
func _on_momma_bird_toggle_mom_presence(): # Don't know why this is here, but it doesn't work
	momIsHome = !momIsHome

func _on_process_momma_bird_toggle_mom_presence():
	momIsHome = !momIsHome
