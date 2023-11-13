extends Node2D

@export var Camera2DScale = 4

func _process(_delta):
	$Camera2D.position = $manager_birds/player_bird/character_bird.global_position / Camera2DScale
	$CanvasLayer/ui_hud/hud_bird/stomach_bar.actualValue = $manager_birds/player_bird.satiation 
	$CanvasLayer/ui_hud/hud_bird/"Sunlight Symbol".modulate.a = .5 * int($manager_birds/player_bird.inSunlight)
	$CanvasLayer/ui_hud/hud_bird/bleeding_symbol.modulate.a = .5 * int(bool($manager_birds/player_bird.damage))
	#$CanvasLayer/ui_hud/bleeding_symbol.scale = Vector2(max(1,$manager_birds/player_bird.damage / 100),max(1,$manager_birds/player_bird.damage / 100))


func _on_manager_game_over_game_over_ocurred(reason):
	$CanvasLayer/ui_game_over.visible = true
	$CanvasLayer/ui_game_over/death_reason.text = reason


func _on_process_momma_bird_momma_win_condition():
	if !$CanvasLayer/ui_game_over.visible:
		$CanvasLayer/ui_game_over.visible = true
		$CanvasLayer/ui_game_over/death_reason.text = "You win"


func _on_manager_birds_player_grew_up():
	if !$CanvasLayer/ui_game_over.visible:
		$CanvasLayer/ui_game_over.visible = true
		$CanvasLayer/ui_game_over/death_reason.text = "You made a good brood parasite!"
