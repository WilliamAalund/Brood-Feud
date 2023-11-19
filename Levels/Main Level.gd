extends Node2D

@export var Camera2DScale = 3

func _process(_delta):
	$Camera2D.position.x = $manager_birds/player_bird2/bird_body.global_position.x / Camera2DScale
	$Camera2D.position.y = $manager_birds/player_bird2/bird_body.global_position.y / Camera2DScale
	#$CanvasLayer/ui_hud/hud_bird/stomach_bar.value = $manager_birds/player_bird.satiation
	$CanvasLayer/ui_hud/hud_bird_2/stomach_bar2.hungerValue = $manager_birds/player_bird2.satiation
	$"CanvasLayer/ui_hud/hud_bird_2/Sunlight Symbol".modulate.a = .6 * int($manager_birds/player_bird2.inSunlight)
	$CanvasLayer/ui_hud/hud_bird_2/bleeding_symbol.modulate.a = .6 * int(bool($manager_birds/player_bird2.damage))
	
	#$CanvasLayer/ui_hud/hud_bird/"Sunlight Symbol".modulate.a = .5 * int($manager_birds/player_bird.inSunlight)
	#$CanvasLayer/ui_hud/hud_bird/bleeding_symbol.modulate.a = .5 * int(bool($manager_birds/player_bird.damage))
	#$CanvasLayer/ui_hud/bleeding_symbol.scale = Vector2(max(1,$manager_birds/player_bird.damage / 100),max(1,$manager_birds/player_bird.damage / 100))


func _on_manager_game_over_game_over_ocurred(reason):
	$CanvasLayer/ui_game_over.visible = true
	$CanvasLayer/ui_game_over/death_reason.text = reason
	$CanvasLayer/ui_game_over/returntomainmenubutton.grab_focus()

func _on_process_momma_bird_momma_win_condition():
	if !$CanvasLayer/ui_game_over.visible:
		$CanvasLayer/ui_game_over.visible = true
		$CanvasLayer/ui_game_over/death_reason.text = "You win"
		$CanvasLayer/ui_game_over/returntomainmenubutton.grab_focus()


func _on_manager_birds_player_grew_up():
	if !$CanvasLayer/ui_game_over.visible:
		$CanvasLayer/ui_game_over.visible = true
		$CanvasLayer/ui_game_over/death_reason.text = "You made a good brood parasite!"
		$CanvasLayer/ui_game_over/returntomainmenubutton.grab_focus()


func _on_manager_birds_player_attacked():
	$CanvasLayer/ui_hud.damageOverlayAnimation()
