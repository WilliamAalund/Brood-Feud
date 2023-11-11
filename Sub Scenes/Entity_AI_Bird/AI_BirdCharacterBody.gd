extends CharacterBody2D

const AGGRESSIVE_DISTANCE_AWAY_FROM_PLAYER = 45 # Distance bird will keep itself from the player when attacking

@onready var nav: NavigationAgent2D = $NavigationAgent2D
#how fast this dude can spin
@export var rotspeed = 0.05
#how inaccurate this dude's pathfinding can be
@export var rot_dead_zone = 1.0

var speed = 40
var accel = speed
var push_force = 80.0
var state = 0 # Variable used for pathfinding logic. Value is managed in parent node
var target = Vector2(0,0)
var direction = Vector3()
var foodTargetsArray = []
var sunrayTargetsArray = []
var sunrayTarget
var foodTarget
var playerTarget = Vector2(0,0)

func _physics_process(delta): # Main pathfinding loop
		updateTargetArrays()
		Callable(self, "state" + str(state)).call(delta) # Calls the associated lambda function
		#callMovementLambda(delta, state)
func moveToTarget(_delta, myTarget):
	nav.target_position = myTarget # Sets target position
	
	var move_dir = Vector2(0, 0)
	move_dir = Vector2(0, - 1).rotated(rotation) # Angles movement vector to direction
	
	velocity = move_dir * speed # Vector time scalar is vector quantity
	move_and_slide()
	
	move_dir.normalized() # Do we need to do this? move_dir is already a unit vector - William 
	
	direction = nav.get_next_path_position() - global_position
	direction = direction.normalized()
	
	var move_rad = move_dir.angle()
	var dir_rad = direction.angle()
	var rad_diff = dir_rad - move_rad
	if (rad_diff > PI): #this means that the angles are closer than math would indicate. modulus stuff
		rad_diff = dir_rad - ((2*PI)-move_rad)
	if rad_to_deg(rad_diff) < (0-rot_dead_zone): #right turn
		rotation -= rotspeed
	elif rad_to_deg(rad_diff) > (0+rot_dead_zone): #left turn
		rotation += rotspeed
#	elif rad_to_deg(rad_diff) < rot_dead_zone:
#		rotation = move_dir.angle_to(myTarget)
#	elif rad_to_deg((2*PI) - rad_diff) < rot_dead_zone:
#		rotation = (2*PI) - move_dir.angle_to(myTarget)
func updateTargetArrays():
	foodTargetsArray = []
	sunrayTargetsArray = []
	for area in $detector_zone.get_overlapping_areas():
		if area.is_in_group("food"):
			foodTargetsArray.append(area.global_position)
		else: if area.is_in_group("sunray"):
			sunrayTargetsArray.append(area.global_position)
		else: if area.is_in_group("player"):
			playerTarget = area.global_position
func findClosestTarget(array):
	if array.size() == 0:
		print("Error: array contains no values")
		return self.position
	var index = 0
	var closestPosition = array[0]
	for item in array:
		if (self.position).length() - item.length() < closestPosition.length():
			#index = item.index
			closestPosition = item
	return closestPosition
func createIdlePosition():
	return Vector2(self.position.x + randi_range(-20,20),self.position.y + randi_range(-20,20))

# --- STATE FUNCTIONS ---
func state1(delta): # Remains idle
	pass
	# moveToTarget(delta, self.position)
	# If idle target equals a sentinel value
	# run a check to see if you should generate a new idle target
	# if you generate a new one, moveToTarget(delta, idleTarget)
func state2(delta): # Will move towards and look for food
	if get_parent().noticedFood:
		foodTarget = findClosestTarget(foodTargetsArray)
		moveToTarget(delta, foodTarget)
	else:
		moveToTarget(delta, Vector2(0.0,50.0)) # Code to get the bird to crowd around momma bird
func state3(delta): # Follows player
	if (self.position - playerTarget).length() > AGGRESSIVE_DISTANCE_AWAY_FROM_PLAYER:
		moveToTarget(delta, playerTarget)
func state4(delta): # Will move to sunray
	if !get_parent().inSunlight:
		sunrayTarget = findClosestTarget(sunrayTargetsArray)
		moveToTarget(delta, sunrayTarget)
func state5(_delta): # Will run to edge of nest
	pass
func state6(_delta): # Will remain entirely immobile. Dead
	pass
func state7(_delta): # Debugger state
	pass
func state8(_delta): # Unallocated state
	pass

#var state_1 = func (delta): # Remains idle
#	pass
#var state_2 = func (delta): # Will move towards and look for food
#	if get_parent().noticedFood:
#		moveToTarget(delta, get_parent().targetFood)
#	else:
#		pass # Code to get the bird to crowd around momma bird
#var state_3 = func (delta): # Follows player
#	#get_global_mouse_position() 2D vector
#	moveToTarget(delta, target)
#var state_4 = func (delta): # Will move to sunray
#	if !get_parent().inSunlight:
#		moveToTarget(delta, get_parent().targetSunray)
#var state_5 = func (delta): # Will run to edge of nest
#	pass
#var state_6 = func (delta): # Will remain entirely immobile. Dead
#	pass
#var state_7 = func (delta): # Debugger state
#	pass
#var state_8 = func (delta): # Unallocated state
#	pass
#var movementLambdasArray = [state1, state2, state3, state4, state5, state6, state7] # Array of lambda functions. Each function corresponds to a state, and contains instructions for pathfinding
