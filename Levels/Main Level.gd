extends Node2D

@export var Camera2DScale = 4

func _process(_delta):
	$Camera2D.position = $BirdControl/Player.position / Camera2DScale
	$CanvasLayer/UI_hud/ProgressBar_Visual.value = $BirdControl/Player.satiation 
	$CanvasLayer/UI_hud/"Sunlight Symbol".modulate.a = .5 * int($BirdControl/Player.inSunlight)
