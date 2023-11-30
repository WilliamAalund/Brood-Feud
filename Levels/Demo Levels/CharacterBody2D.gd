extends CharacterBody2D

var push_force = 120.0
var move_speed = 100

func _physics_process(_delta):
	
	var move_dir = Vector2(0, 0)
	if Input.is_action_pressed("up"):
		move_dir += Vector2(0, - Input.get_action_strength("up")).rotated(rotation)
	if Input.is_action_pressed("down"):
		move_dir += Vector2(0, Input.get_action_strength("down")).rotated(rotation)
	if Input.is_action_pressed("left"):
		move_dir += Vector2(-Input.get_action_strength("left"), 0).rotated(rotation)
	if Input.is_action_pressed("right"):
		move_dir += Vector2(Input.get_action_strength("right"), 0).rotated(rotation)

	velocity = move_dir * move_speed
	move_and_slide()
	
			
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody2D:
			print(-c.get_normal() * push_force)
			#-c.get_normal() * push_force
			c.get_collider().apply_force(c.get_normal() * -push_force)
		
