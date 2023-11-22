extends Node2D

const SPAWN_OFFSET = 100
const MIN_SUNRAYS_TO_SPAWN = 8
const MAX_SUNRAYS_TO_SPAWN = 12
const MIN_INTERVAL_BETWEEN_SUNRAY_SPAWN = 3
const MAX_INTERVAL_BETWEEN_SUNRAY_SPAWN = 6
const MIN_SUNRAY_SCALE_VALUE = 0.8
const MAX_SUNRAY_SCALE_VALUE = 1.2

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
	var scale = randf_range(MIN_SUNRAY_SCALE_VALUE, MAX_SUNRAY_SCALE_VALUE)
	sunray_instance.scale = Vector2(scale,scale)
	self.add_child(sunray_instance)

func spawnSunrays():
	var i = 0
	var sunraysToSpawn = randi_range(MIN_SUNRAYS_TO_SPAWN,MAX_SUNRAYS_TO_SPAWN)
	var sunraySpawnInterval
	while i < sunraysToSpawn and momIsHome == false:
		spawnSunray()
		sunraySpawnInterval = randi_range(MIN_INTERVAL_BETWEEN_SUNRAY_SPAWN, MAX_INTERVAL_BETWEEN_SUNRAY_SPAWN)
		await get_tree().create_timer(sunraySpawnInterval).timeout
		i += 1
