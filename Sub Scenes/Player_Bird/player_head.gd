extends CharacterBody2D

#for debugging
@export var angle_padding = 0
var isInteracting = false

func get_input():
	look_at(get_global_mouse_position())
	rotation += deg_to_rad(angle_padding)

func _physics_process(_delta):
	get_input()
	move_and_slide()
	
func _process(delta):
	if Input.is_action_pressed("interact") and !isInteracting:
		isInteracting = true
		$CollisionShape2D/Sprite2D.modulate = Color(0,1,0)
		await get_tree().create_timer(0.1).timeout
		$beak_area.add_to_group("eater")
		$beak_area.add_to_group("attacker")
		$CollisionShape2D/Sprite2D.modulate = Color(1,0,0)
		await get_tree().create_timer(0.1).timeout
		$beak_area.remove_from_group("eater")
		$beak_area.remove_from_group("attacker")
		$CollisionShape2D/Sprite2D.modulate = Color(1,1,1,1)
		await get_tree().create_timer(0.2).timeout
		isInteracting = false
		
