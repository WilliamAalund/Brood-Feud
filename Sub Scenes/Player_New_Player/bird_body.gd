extends CharacterBody2D

var move_speed = 100
var rotate_speed = 0.05  # Adjust this value to control the rotation speed
var push_force = 80.0

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
		
