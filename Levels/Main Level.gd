extends Node2D

@export var Camera2DScale = 4

func _process(_delta):
	$Camera2D.position = $manager_birds/player_bird/character_bird.global_position / Camera2DScale
	$CanvasLayer/ui_hud/ProgressBar_Visual.value = $manager_birds/player_bird.satiation 
	$CanvasLayer/ui_hud/"Sunlight Symbol".modulate.a = .5 * int($manager_birds/player_bird.inSunlight)