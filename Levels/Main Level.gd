extends Node2D

@export var Camera2DScale = 3

func _ready():
	Game_Parameters.gameOccurring = true

func _process(_delta): # Updates camera position, and provides UI with needed elements
	updateHud()

func updateHud():
	$Camera2D.position.x = $manager_birds/player_bird2/bird_body.global_position.x / Camera2DScale # Camera
	$Camera2D.position.y = $manager_birds/player_bird2/bird_body.global_position.y / Camera2DScale
	$CanvasLayer/ui_hud/hud_bird_2/stomach_bar2.hungerValue = $manager_birds/player_bird2.satiation # Satiation
	$CanvasLayer/ui_hud/hud_bird_2/hud_bird_progress_bar.value = $manager_birds/player_bird2.experience # Exp bar (Not implemented intentionally)
	if $manager_birds/player_bird2.experience == Game_Parameters.PLAYER_EXPERIENCE_TO_LEVEL_UP: # Level up animation
		$CanvasLayer/ui_hud.levelUpHudAnimation()
	if $manager_birds/player_bird2.satiation <= Game_Parameters.STARVATION_THRESHOLD:
		$CanvasLayer/ui_hud.isStarving = true
	else:
		$CanvasLayer/ui_hud.isStarving = false
	$"CanvasLayer/ui_hud/hud_bird_2/Sunlight Symbol".modulate.a = .6 * int($manager_birds/player_bird2.inSunlight) # Sunlight hud symbol
	$CanvasLayer/ui_hud/hud_bird_2/bleeding_symbol.modulate.a = .6 * int(bool($manager_birds/player_bird2.damage)) # Bleeding hud symbol
	$CanvasLayer/ui_hud/hud_bird_2/worm_symbols_manager.foodInStomach = $manager_birds/player_bird2.foodInStomach
	$CanvasLayer/ui_hud/hud_bird_2/worm_symbols_manager.stomachCapacity = $manager_birds/player_bird2.stomachCapacity

func _on_manager_game_over_game_over_ocurred(reason):
	if Game_Parameters.gameOccurring:
		Game_Parameters.gameOccurring = false
		$CanvasLayer/ui_game_over.visible = true
		$CanvasLayer/ui_game_over/Dead_bird.visible = true
		$CanvasLayer/ui_game_over/death_reason.text = reason
		$CanvasLayer/ui_game_over/final_age.text = "Final age: " + str($manager_birds/player_bird2.age)
		$CanvasLayer/ui_game_over/returntomainmenubutton.grab_focus()

func _on_process_momma_bird_momma_win_condition():
	if !$CanvasLayer/ui_game_over.visible:
		$CanvasLayer/ui_game_over/Cuckoo.visible = true
		$CanvasLayer/ui_game_over.visible = true
		$CanvasLayer/ui_game_over/death_reason.text = "You win"
		$CanvasLayer/ui_game_over/returntomainmenubutton.grab_focus()

func _on_manager_birds_player_grew_up():
	if Game_Parameters.gameOccurring:
		Game_Parameters.gameOccurring = false
		$CanvasLayer/ui_game_over.visible = true
		$CanvasLayer/ui_game_over/death_reason.text = "You made a good brood parasite!"
		$CanvasLayer/ui_game_over/returntomainmenubutton.grab_focus()

func _on_manager_birds_player_attacked():
	$CanvasLayer/ui_hud.damageOverlayAnimation()
