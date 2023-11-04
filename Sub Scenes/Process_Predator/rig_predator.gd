extends Node2D

#func _ready():
	#shadowFlyOver()
	#togglePredator()

func shadowFlyOver():
	$predator_shadow.visible = true
	$predator_shadow.global_position = Vector2(100,100)
	var i = 0
	while i < 50:
		$predator_shadow.position.x -= 5
		$predator_shadow.position.y -= 5
		i += 1
		await $Timer.timeout
	$predator_shadow.visible = false

func togglePredator():
	$predator_body.visible = !$predator_body.visible


func _on_predator_toggle_predator_presence():
	togglePredator()


func _on_predator_toggle_predator_approach():
	shadowFlyOver()
