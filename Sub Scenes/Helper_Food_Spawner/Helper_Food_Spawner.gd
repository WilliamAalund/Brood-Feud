extends Node2D

signal child_food_eaten

@export var spawn_offset = 55 # Value that determines amount of potential offset for a food spawn
# TODO: Create a separate helper function that does the calculations for the position of a food drop.
var food_scene = load("res://Sub Scenes/Helper_Food_Spawner/Object_Food/object_food.tscn")

func add_food(spawn_inaccuracy: int = spawn_offset): #Spawn inaccuracy can by dynamically set
	var food_instance = food_scene.instantiate()
	food_instance.position.x += randi_range(-spawn_inaccuracy, spawn_inaccuracy) % spawn_inaccuracy # Randomly varies spawn position around Object_Food_Spawner
	food_instance.position.y += randi_range(-spawn_inaccuracy, spawn_inaccuracy) % spawn_inaccuracy
	self.add_child(food_instance)
	
func on_food_eaten(): # Function called by child food nodes. Connects to hunger control to transmit food signal
	#print("received on eaten function")
	emit_signal("child_food_eaten")
	
	
func _on_button_pressed(): #Used for debugging
	add_food()

func _on_momma_bird_mom_drops_food(): # Signal passed by momma bird scene. Timing and intervals of food spawning is handled in the momma bird scene
	add_food()
