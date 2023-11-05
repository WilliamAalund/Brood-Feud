extends CharacterBody2D

const INTERACT_INPUT_DELAY = 0.1 # In seconds
const INTERACT_LENGTH = 0.2 # In seconds
const INTERACT_COOLDOWN = 0.2 # In seconds

var isInteracting = false
var move_speed = 100 # Adjust this value to control movement speed
var rotate_speed = 0.05  # Adjust this value to control the rotation speed
var push_force = 80.0 # For some advanced physics, currently unused

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
			print(-c.get_normal() * push_force)
			#-c.get_normal() * push_force
			c.get_collider().apply_force(c.get_normal() * -push_force)
		

func _input(event):
	if event.is_action_pressed("interact") && !isInteracting:
		emit_signal("player_attacks")
		isInteracting = true
		await get_tree().create_timer(INTERACT_INPUT_DELAY).timeout
		# Attack
		$beak_area.monitorable = true
		$beak_area.monitoring = true
		$beak_area/beak_sprite.visible = true
		Input.start_joy_vibration(0, 0, 1, 0.2)
		await get_tree().create_timer(INTERACT_LENGTH).timeout
		$beak_area.monitorable = false
		$beak_area.monitoring = false
		$beak_area/beak_sprite.visible = false
		# Wait a bit after attack
		await get_tree().create_timer(INTERACT_COOLDOWN).timeout
		isInteracting = false
