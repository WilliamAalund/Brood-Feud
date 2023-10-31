extends CharacterBody2D

var speed = 40
var accel = speed
var state = 0 # Variable used for pathfinding logic. Value is managed in parent node
var target = Vector2(0,0)
var direction = Vector3()
@onready var nav: NavigationAgent2D = $NavigationAgent2D

func _physics_process(delta): #Physics process should not have any logic. Logical problems should be handled outside the function
	callMovement(delta)

func state0(_delta): # Stays in egg
	pass

func state1(_delta): # Remains idle
	pass

func state2(delta): # Will move towards and look for food
	#get_global_mouse_position() 2D vector
	if get_parent().noticedFood:
		nav.target_position = get_parent().targetFood
	
		direction = nav.get_next_path_position() - global_position
		direction = direction.normalized()
	
		velocity = velocity.lerp(direction * speed , accel * delta)
	
		move_and_slide()
	else:
		pass # Code to get the bird to crowd around momma bird
	
	#nav.target_position = target
	
	#direction = nav.get_next_path_position() - global_position
	#direction = direction.normalized()
	
	#velocity = velocity.lerp(direction * speed , accel * delta)
	
	#move_and_slide()

func state3(delta): # Follows player
	#get_global_mouse_position() 2D vector
	nav.target_position = target
	
	direction = nav.get_next_path_position() - global_position
	direction = direction.normalized()
	
	velocity = velocity.lerp(direction * speed , accel * delta)
	
	move_and_slide()

func state4(delta): # Will move to sunray
	if !get_parent().inSunray:
		nav.target_position = get_parent().targetSunray
		#print(get_parent().targetSunray)
	
		direction = nav.get_next_path_position() - global_position
		direction = direction.normalized()
	
		velocity = velocity.lerp(direction * speed , accel * delta)
	
		move_and_slide()
	
func state5(_delta): # Will run to edge of nest
	pass
	
func state6(_delta): # Will remain entirely immobile. Dead
	pass

# TODO: Aparrently, you can pass functions as parameters somehow.
# There should be an extremely easy way to tell the navigation agent to just do 
# x navigation behavior, where x is just the state value.
# The NavigationAgent2D currently uses a switch case system (called match in Godot)
# to choose the correct path. Ideally, it shouldn't have to "choose" at all.
# (For example, state 1 will just make the body call the state 1 pathfinding option,
# instead of using a case or if statement to call the state 1 function.)

func callMovement(delta):
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
