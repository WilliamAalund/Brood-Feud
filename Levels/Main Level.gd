extends Node2D

@export var Camera2DScale = 4

func _process(_delta):
	$Camera2D.position = $BirdControl/player_bird/character_bird.global_position / Camera2DScale
	$CanvasLayer/UI_hud/ProgressBar_Visual.value = $BirdControl/player_bird.satiation 
	$CanvasLayer/UI_hud/"Sunlight Symbol".modulate.a = .5 * int($BirdControl/player_bird.inSunlight)
