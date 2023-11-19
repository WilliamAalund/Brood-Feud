extends CharacterBody2D

var roost_target_position = Vector2(0,0) # Both of these variables are managed by the rig_momma_bird node.
var fly_off_target_position = Vector2(0,0)
var foodTargetPosition = Vector2(0,0)

var move_speed = 4
var flyingIn = false
var rotationSpeed = 0.05

func _physics_process(_delta):
	var fly_direction
	if flyingIn: # If momma bird is flying into the nest
		fly_direction = roost_target_position - self.global_position # roost_target_position + self.global_position
	else: # If momma bird is flying out HELP HELP HELP!!!!!!
		fly_direction = fly_off_target_position - self.position
	velocity = fly_direction * move_speed
	move_and_slide()
	if (self.position - roost_target_position).length() <= 0.5:
		self.position = roost_target_position
		$CollisionShape2D.disabled = false
		# I don't know what I am doing. help me
#	if abs(get_angle_to(foodTargetPosition - $momma_body/momma_head.global_position) * 4) > 1:
#		print("bruh") 
#		$momma_body/momma_head.rotation += rotationSpeed
	$momma_body/momma_head.rotation = get_angle_to(foodTargetPosition - $momma_body/momma_head.global_position) * 4
  
func flyIn():
	flyingIn = true
	$CollisionShape2D.disabled = false
	self.visible = true
	self.position.y = -600

func flyOut():
	flyingIn = false
	$CollisionShape2D.disabled = true

func _on_rig_momma_bird_toggle_fly():
	if !flyingIn:
		flyIn()
	else:
		flyOut()
