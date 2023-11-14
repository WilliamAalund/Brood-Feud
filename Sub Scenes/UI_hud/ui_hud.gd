extends Control


func _ready():
	$damage_overlay.modulate.a = 0
#	damageOverlayAnimation()
func _physics_process(delta):
	if $damage_overlay.modulate.a > 0:
		$damage_overlay.modulate.a -= 0.02
	
func damageOverlayAnimation():
	$damage_overlay.visible = true
	$damage_overlay.modulate.a = .4
