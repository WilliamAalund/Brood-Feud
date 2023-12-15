extends Node2D

const PREDATOR_SHADOW_RESTING_POSITION_X = -500
const PREDATOR_SHADOW_RESTING_POSITION_Y = 100


var move_speed = 20

func _ready():
	$predator_shadow.global_position.x = PREDATOR_SHADOW_RESTING_POSITION_X
	$predator_shadow.global_position.y = PREDATOR_SHADOW_RESTING_POSITION_Y
	#shadowFlyOver()

func _physics_process(_delta): # This code moves the predator shadow. As long as it isnt in the correct x position it will display and move to the left.
	if $predator_shadow.position.x > -500:
		$predator_shadow.visible = true
		$predator_shadow.position.x -= move_speed
	else:
		$predator_shadow.visible = false

func shadowFlyOver(): # This code prepares the predator shadow to display.
	$predator_shadow.visible = true
	$predator_shadow.global_position = Vector2(500,PREDATOR_SHADOW_RESTING_POSITION_Y)

func togglePredator():
	$predator_body.visible = !$predator_body.visible


func _on_predator_toggle_predator_presence():
	togglePredator()


func _on_predator_toggle_predator_approach():
	shadowFlyOver()
