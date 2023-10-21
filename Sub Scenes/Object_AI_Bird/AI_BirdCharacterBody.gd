extends CharacterBody2D

var speed = 30
var accel = 30
var state # Variable that gets passed the state variable
var target = Vector2(0,0)

@onready var nav: NavigationAgent2D = $NavigationAgent2D

func _enter_tree():
	state = get_parent().state # Immedeately grabs parent state 

func _physics_process(delta): #Physics process should not have any logic. Logical problems should be handled outside the function
	callMovement(state, delta)

func state0(delta): # Stays in egg
	print("State 0 does not have an implemented navigation method")

func state1(delta): # Remains idle
	pass

func state2(delta): # Will move towards and look for food
	print("State 2 does not have an implemented navigation method")

func state3(delta): # Follows player
	var direction = Vector3()
	#get_global_mouse_position() 2D vector
	nav.target_position = target
	
	direction = nav.get_next_path_position() - global_position
	direction = direction.normalized()
	
	velocity = velocity.lerp(direction * speed , accel * delta)
	
	move_and_slide()

func state4(delta): # Will move to sunspot
	print("State 4 does not have an implemented navigation method")
	
func state5(delta): # Will run to edge of nest
	print("State 5 does not have an implemented navigation method")
	
func state6(delta): # Will remain entirely immobile. Dead
	print("State 6 does not have an implemented navigation method")

func callMovement(state, delta):
	match state:
		1:
			state1(delta)
		2:
			state2(delta)
		3:
			state3(delta)
		4:
			state4(delta)
		5:
			state5(delta)
		6:
			state6(delta)
