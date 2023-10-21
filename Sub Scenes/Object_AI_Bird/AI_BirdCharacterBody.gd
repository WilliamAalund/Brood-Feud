extends CharacterBody2D

var speed = 50
var accel = 50

@onready var nav: NavigationAgent2D = $NavigationAgent2D

var target = Vector2(0,0)

func _physics_process(delta):
	var direction = Vector3()
	#get_global_mouse_position() 2D vector
	nav.target_position = target
	
	direction = nav.get_next_path_position() - global_position
	direction = direction.normalized()
	
	velocity = velocity.lerp(direction * speed , accel * delta)
	
	move_and_slide()

