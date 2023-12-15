extends Control

# Satiation bar value, and hud icons are handled in the Main Level script
var isStarving = false

func _ready():
	$damage_overlay.modulate.a = 0
	levelUpHudAnimation()
#	damageOverlayAnimation()

func _physics_process(_delta):
	if $damage_overlay.modulate.a > 0:
		$damage_overlay.modulate.a -= 0.02
	if isStarving and $AnimationPlayer.current_animation != "damage_taken":
		$AnimationPlayer.play("starving")
		$StarvingColorBlock.visible = true
	else: if $AnimationPlayer.current_animation == "starving":
		$AnimationPlayer.stop()
		$StarvingColorBlock.visible = false

func damageOverlayAnimation():
	$damage_overlay.visible = true
	$damage_overlay.modulate.a = .3
	$AnimationPlayer.stop()
	$AnimationPlayer.play("damage_taken")

func levelUpHudAnimation():
	$hud_bird_2/hud_bird_progress_bar.modulate = Color(0.0,1,0.0,1)
	while $hud_bird_2/hud_bird_progress_bar.modulate.r < 1:
		$hud_bird_2/hud_bird_progress_bar.modulate += Color(0.1, 0, 0.1, 0)
		await get_tree().create_timer(0.1).timeout
