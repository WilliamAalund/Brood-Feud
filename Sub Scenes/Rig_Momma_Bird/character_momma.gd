extends CharacterBody2D

#const ROOST_TARGET_POSITION_Y = 100
#const ROOST_TARGET_POSITION_X = 0
#const ROOST_TARGET_POSITION = Vector2(ROOST_TARGET_POSITION_X,ROOST_TARGET_POSITION_Y)

var roost_target_position = Vector2(0,0)
var fly_off_target_position = Vector2(0,0)

var move_speed = 4
var flyingIn = false

#func _ready():
#	print(roost_target_position)
#	flyIn()
#	await get_tree().create_timer(5).timeout
#	flyOut()

func _physics_process(delta):
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
