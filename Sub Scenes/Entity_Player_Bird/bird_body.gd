extends CharacterBody2D

const BIRD_HEAD_ROTATION_ABSOLUTE_MAXIMUM_BOUND = 0.33

var isInteracting = false
var isFull = false
var move_speed = 70 # Adjust this value to control movement speed
var rotate_speed = 0.05  # Adjust this value to control the rotation speed
var push_force = 2400.0 # Value used when calculating impulse to apply
var sizeExperience = 0

signal player_attacks

func _physics_process(_delta):
	var move_dir = Vector2(0, 0)
	if Input.is_action_pressed("up"):
		move_dir = Vector2(0, - Input.get_action_strength("up")).rotated(rotation)
	elif Input.is_action_pressed("down"):
		move_dir = Vector2(0, Input.get_action_strength("down")).rotated(rotation)

	velocity = move_dir * move_speed
	move_and_slide()
	if Input.is_action_pressed("up") or Input.is_action_pressed("down"):
		if Input.is_action_pressed("left"):
			rotation -= Input.get_action_strength("left") * rotate_speed
		elif Input.is_action_pressed("right"):
			rotation += Input.get_action_strength("right") * rotate_speed
			
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody2D:
			c.get_collider().apply_force(c.get_normal() * -push_force)
			
	$bird_head.rotation = (-Input.get_action_strength("left") + Input.get_action_strength("right")) / 2
	if $bird_head.rotation > BIRD_HEAD_ROTATION_ABSOLUTE_MAXIMUM_BOUND:
		$bird_head.rotation = BIRD_HEAD_ROTATION_ABSOLUTE_MAXIMUM_BOUND
	else: if $bird_head.rotation < -BIRD_HEAD_ROTATION_ABSOLUTE_MAXIMUM_BOUND:
		$bird_head.rotation = -BIRD_HEAD_ROTATION_ABSOLUTE_MAXIMUM_BOUND
		
	if sizeExperience > 0:
		self.scale += Vector2(Game_Parameters.LEVEL_UP_SCALE_INCREASE / 20,Game_Parameters.LEVEL_UP_SCALE_INCREASE / 20)
		self.modulate = Color(.5 + (sizeExperience / 20.0),1,.5 + (sizeExperience / 20.0),1)
		sizeExperience -= 1
		if sizeExperience <= 0:
			self.modulate = Color(1,1,1,1)

func _input(event):
	if event.is_action_pressed("interact") && !isInteracting: # Makes sure script can't run while the player is already interacting
		emit_signal("player_attacks")
		isInteracting = true
		$AnimationPlayer.play("peck")
		await get_tree().create_timer(Game_Parameters.INTERACT_INPUT_DELAY).timeout
		# Attack
		if !isFull:
			$bird_head.add_to_group("eater")
		$bird_head.monitorable = true
		$bird_head.monitoring = true
		$bird_head/bird_head_collider/bird_head_sprite.modulate = Color(1,.8,.8,1)
		Input.start_joy_vibration(0, 0, 1, 0.2)
		#print("Vibration: RigPlayerBirdbirdbody")
		await get_tree().create_timer(Game_Parameters.INTERACT_LENGTH).timeout
		$bird_head.monitorable = false
		$bird_head.monitoring = false
		$bird_head/bird_head_collider/bird_head_sprite.modulate = Color(1,1,1,1)
		# Wait a bit after attack
		$bird_head.remove_from_group("eater")
		await get_tree().create_timer(Game_Parameters.INTERACT_COOLDOWN).timeout
		isInteracting = false

func ageUpBody():
	levelUpStats()
	sizeExperience += 20

func levelUpStats():
	push_force += Game_Parameters.LEVEL_UP_PUSH_FORCE_INCREASE # Increase stats
	move_speed += Game_Parameters.LEVEL_UP_MOVE_SPEED_INCREASE

func levelUpAnimation():
	pass

func changeSpriteToGrown():
	print("changeSpriteToGrown function is not implemented")
#	var newBird = preload("res://Visuals/Art Assets/draft_player_older_bird.png")
#	$character_bird/body_sprite.texture = newBird
