extends Control

# Satiation bar value, and hud icons are handled in the Main Level script

func _ready():
	$damage_overlay.modulate.a = 0
	levelUpHudAnimation()
#	damageOverlayAnimation()

func _physics_process(_delta):
	if $damage_overlay.modulate.a > 0:
		$damage_overlay.modulate.a -= 0.02

func damageOverlayAnimation():
	$damage_overlay.visible = true
	$damage_overlay.modulate.a = .4

func levelUpHudAnimation():
	$hud_bird_2/hud_bird_progress_bar.modulate = Color(0.0,1,0.0,1)
	while $hud_bird_2/hud_bird_progress_bar.modulate.r < 1:
		$hud_bird_2/hud_bird_progress_bar.modulate += Color(0.1, 0, 0.1, 0)
		await get_tree().create_timer(0.1).timeout
