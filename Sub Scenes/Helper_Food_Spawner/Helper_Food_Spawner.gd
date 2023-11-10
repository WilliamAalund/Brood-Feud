extends Node2D

const MINIMUM_FOOD_DISTANCE_FROM_BIRDS = 45

@export var spawn_offset = 75 # Value that determines amount of potential offset for a food spawn
# TODO: Create a separate helper function that does the calculations for the position of a food drop.
var food_scene = load("res://Sub Scenes/Helper_Food_Spawner/Entity_Food/entity_food.tscn")

func add_food(): #Spawn inaccuracy can by dynamically set
	var food_instance = food_scene.instantiate()
	food_instance.position = calculateFoodSpawnPosition()
	self.add_child(food_instance)
	
func calculateFoodSpawnPosition():
	var validSpawn = false
	var birdPositions = [] # Stores Global Position of all birds.
	var i = 0
	for area in $bird_position_grabber.get_overlapping_areas():
		if area.is_in_group("bird") or area.is_in_group("eater"):
			birdPositions.append(area.global_position)
	while (!validSpawn and i < 500):
		$dummy_spawn.position = Vector2(randi_range(-spawn_offset, spawn_offset), randi_range(-spawn_offset, spawn_offset))
		validSpawn = true
		for bird in birdPositions: # If none of the birds are close to the new position, validSpawn will remain true
			if ($dummy_spawn.global_position - bird).length() < MINIMUM_FOOD_DISTANCE_FROM_BIRDS:
				validSpawn = false
		i += 1
	if validSpawn:
		return Vector2($dummy_spawn.position.x,$dummy_spawn.position.y)
	else:
		print("No valid food position found: returning arbitrary coordinates")
		return Vector2(randi_range(-spawn_offset, spawn_offset) % spawn_offset,randi_range(-spawn_offset, spawn_offset) % spawn_offset)

func _on_button_pressed(): #Used for debugging
	add_food()

func _on_momma_bird_mom_drops_food(): # Signal passed by momma bird scene. Timing and intervals of food spawning is handled in the momma bird scene
	add_food()
