extends CharacterBody2D

@export var move_speed : float = 100
@export var push_force : float = 20

func _ready():
	print(self.position)

func _physics_process(_delta):
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	velocity = input_direction * move_speed
	move_and_slide()
	#var tar_rot = get_angle_to(get_global_mouse_position())
	#rotation = tar_rot
	#for i in get_slide_collision_count():
	#	var c = get_slide_collision(i)
	#	if c.get_collider() is RigidBody2D:
	#		c.get_collider().apply_central_impulse(-c.get_normal() * push_force)
	
