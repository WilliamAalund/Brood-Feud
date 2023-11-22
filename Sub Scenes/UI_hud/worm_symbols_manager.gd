extends Node2D

const NOT_FILLED_WORM_ALPHA_VALUE = 0.2
const FILLED_WORM_ALPHA_VALUE = 0.9

var foodInStomach = 0 # Value managed in Main Level scene.
var stomachCapacity = 0

#func _ready():
#	stomachCapacity = 5
#	wormsInStomach = 2
#	updateWorms()

func _process(delta):
	updateWorms()

func updateWorms():
	var currWorm = 1
	while currWorm <= stomachCapacity:
		if currWorm <= foodInStomach:
			fillWorm(currWorm) # Indicate that worm is eaten
		else:
			makeWormVisible(currWorm)
		currWorm += 1

func fillWorm(worm):
	match worm:
		1:
			$worm_1.visible = true
			$worm_1.modulate.a = FILLED_WORM_ALPHA_VALUE
		2:
			$worm_2.visible = true
			$worm_2.modulate.a = FILLED_WORM_ALPHA_VALUE
		3:
			$worm_3.visible = true
			$worm_3.modulate.a = FILLED_WORM_ALPHA_VALUE
		4:
			$worm_4.visible = true
			$worm_4.modulate.a = FILLED_WORM_ALPHA_VALUE
		5:
			$worm_5.visible = true
			$worm_5.modulate.a = FILLED_WORM_ALPHA_VALUE
		6:
			$worm_6.visible = true
			$worm_6.modulate.a = FILLED_WORM_ALPHA_VALUE
		

func makeWormVisible(worm):
	match worm:
		1:
			$worm_1.visible = true
			$worm_1.modulate.a = NOT_FILLED_WORM_ALPHA_VALUE
		2:
			$worm_2.visible = true
			$worm_2.modulate.a = NOT_FILLED_WORM_ALPHA_VALUE
		3:
			$worm_3.visible = true
			$worm_3.modulate.a = NOT_FILLED_WORM_ALPHA_VALUE
		4:
			$worm_4.visible = true
			$worm_4.modulate.a = NOT_FILLED_WORM_ALPHA_VALUE
		5:
			$worm_5.visible = true
			$worm_5.modulate.a = NOT_FILLED_WORM_ALPHA_VALUE
		6:
			$worm_6.visible = true
			$worm_6.modulate.a = NOT_FILLED_WORM_ALPHA_VALUE
