extends CharacterBody2D

const AGGRESSIVE_DISTANCE_AWAY_FROM_PLAYER = 45 # Distance bird will keep itself from the player when attacking

@onready var nav: NavigationAgent2D = $NavigationAgent2D
#how fast this dude can spin
@export var rotspeed = 0.05
#how inaccurate this dude's pathfinding can be
@export var rot_dead_zone = 1.0

var speed = 55
var accel = speed
var push_force = 80.0
var state = 1 # Variable used for pathfinding logic. Value is managed in parent node)
var direction = Vector3()
var foodTargetsArray = []
var sunrayTargetsArray = []
var sunrayTarget
var foodTarget
var idleTarget
var playerTarget
var isInteracting = false

var predator_place = Vector2(0,0)

func _physics_process(delta): # Main pathfinding loop
		Callable(self, "state" + str(state)).call(delta) # Calls the associated lambda function
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


func moveFromTarget(_delta, myTarget): #ran for running away from things. like preditor
	nav.target_position = myTarget # Sets target position
	
	var move_dir = Vector2(0, 0)
	move_dir = Vector2(0, - 1).rotated(rotation) # Angles movement vector to current direction
	
	velocity = move_dir * speed # Vector time scalar is vector quantity
	move_and_slide()
	
	
	direction = nav.get_next_path_position() - global_position
	direction = direction.normalized()
	direction *= Vector2(-1,-1) #KEY LINE: reverses target direction, making bird turn and run instead of go forward
	
	var move_rad = move_dir.angle()
	var dir_rad = direction.angle()
	var rad_diff = dir_rad - move_rad
	if (rad_diff > PI): #this means that the angles are closer than math would indicate. modulus stuff
		rad_diff = dir_rad - ((2*PI)-move_rad)
	if rad_to_deg(rad_diff) < (0-rot_dead_zone): #right turn
		rotation -= rotspeed
	elif rad_to_deg(rad_diff) > (0+rot_dead_zone): #left turn
		rotation += rotspeed
	



func ensureClipping(_delta): # Ran when the bird is not doing anything, but still needs to make sure that it collides properly
	velocity = Vector2(0,0)
	move_and_slide()
func createIdlePosition():
	return Vector2(self.position.x + randi_range(-20,20),self.position.y + randi_range(-20,20))
func beakInteract():
	#emit_signal("ai_bird_attacks")
	if !isInteracting:
		isInteracting = true
		$AnimationPlayer.play("ai_peck")
		await get_tree().create_timer(Game_Parameters.AI_BIRD_INTERACT_INPUT_DELAY).timeout
		# Attack
		$eater_zone.monitorable = true
		$eater_zone.monitoring = true
		#$eater_zone/hitbox_sprite.visible = true
		$bird_sprite_body/bird_sprite_head.modulate = Color(1,1,.70,1)
		await get_tree().create_timer(Game_Parameters.AI_BIRD_INTERACT_LENGTH).timeout
		$eater_zone.monitorable = false
		$eater_zone.monitoring = false
		#$eater_zone/hitbox_sprite.visible = false
		$bird_sprite_body/bird_sprite_head.modulate = Color(1,1,1,1)
		# Wait a bit after attack
		await get_tree().create_timer(Game_Parameters.AI_BIRD_INTERACT_COOLDOWN).timeout
		$eater_detector_zone.monitoring = false
		$eater_detector_zone.monitoring = true
		isInteracting = false
	else:
		print("Beak interact failed: Beak is already activated")

# --- STATE FUNCTIONS ---
func state1(delta): # Remains idle
	ensureClipping(delta)
	# moveToTarget(delta, self.position)
	# If idle target equals a sentinel value
	# run a check to see if you should generate a new idle target
	# if you generate a new one, moveToTarget(delta, idleTarget)
func state2(delta): # Will move towards and look for food
	if get_parent().noticedFood:
		moveToTarget(delta, foodTarget)
	else:
		moveToTarget(delta, Vector2(0.0,-70)) # Code to get the bird to crowd around momma bird
		ensureClipping(delta)
func state3(delta): # Follows player
	moveToTarget(delta, playerTarget)
func state4(delta): # Will move to sunray
	if !get_parent().inSunlight:
		moveToTarget(delta, sunrayTarget)
func state5(delta): # Will run to edge of nest
	if (predator_place == Vector2(0,0)):
		moveToTarget(delta,Vector2(0,210))
	else :
		moveFromTarget(delta,predator_place)
func state6(delta): # Will remain entirely immobile. Dead
	ensureClipping(delta)
func state7(_delta): # Debugger state
	pass
func state8(delta): # Stunned state
	ensureClipping(delta)
