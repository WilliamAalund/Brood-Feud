extends Node2D

const SPAWN_OFFSET = 100
const SUNRAYS_TO_SPAWN = 4
const MIN_INTERVAL_BETWEEN_SUNRAY_SPAWN = 4
const MAX_INTERVAL_BETWEEN_SUNRAY_SPAWN = 10

var sunray_scene = load("res://Sub Scenes/Helper_Sunspots/Entity_Temperature_Zone/temperature_zone.tscn")
var momIsHome = false

func _on_process_momma_bird_toggle_mom_presence():
	momIsHome = !momIsHome
	if momIsHome == false:
		spawnSunrays()

func newRandomPosition():
	var xPos = randi_range(-SPAWN_OFFSET, SPAWN_OFFSET)
	var yPos = randi_range(-SPAWN_OFFSET, SPAWN_OFFSET)
	return Vector2(xPos,yPos)
	
func spawnSunray():
	var newSunrayPosition = newRandomPosition()
	var sunray_instance = sunray_scene.instantiate()
	sunray_instance.position = newSunrayPosition
	self.add_child(sunray_instance)

func spawnSunrays():
	var i = 0
	var sunraySpawnInterval
	while i < SUNRAYS_TO_SPAWN and momIsHome == false:
		spawnSunray()
		sunraySpawnInterval = randi_range(MIN_INTERVAL_BETWEEN_SUNRAY_SPAWN, MAX_INTERVAL_BETWEEN_SUNRAY_SPAWN)
		await get_tree().create_timer(sunraySpawnInterval).timeout
		i += 1
