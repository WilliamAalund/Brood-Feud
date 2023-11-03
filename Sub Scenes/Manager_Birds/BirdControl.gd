extends Node2D

# Values that each of the birds can refer to in order to make decisions about themselves/what they want to do.
@export var foodRestore = 12
@export var idleSatiationDrainRate = 0.06
@export var sunRate = -0.02
@export var debug = false

var momIsHome = false # Toggled by toggle_mom_presence signal, sent by momma bird.
var isSunspot = false # Toggled in the Main Level scene's attached script.

signal AI_Bird_Move(target_position)
signal Birds_Increment_Hunger()
signal player_starved

func _ready():
	if debug:
		$AI_Bird.debug = true

func _physics_process(_delta):
	emit_signal("AI_Bird_Move", $player_bird.position)

func _on_process_momma_bird_toggle_mom_presence(): 
	momIsHome = !momIsHome

func _on_timer_timeout():
	emit_signal("Birds_Increment_Hunger")

func _on_player_bird_player_starved():
	emit_signal("player_starved")
	







#func _ready():
	#var aiBirdInstance = food_scene.instantiate()
	#food_instance.position.x += randi_range(-spawn_inaccuracy, spawn_inaccuracy) % spawn_inaccuracy # Randomly varies spawn position around Object_Food_Spawner
	#food_instance.position.y += randi_range(-spawn_inaccuracy, spawn_inaccuracy) % spawn_inaccuracy
	#self.add_child(food_instance)

#func _on_player_player_starved(): # Communicated with the Manager_Game_Over node.
	#emit_signal("playerStarved()")
