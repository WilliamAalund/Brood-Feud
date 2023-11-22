extends Node2D

const LIFESPAN_MIN = 3
const LIFESPAN_MAX = 7
const MIN_STATE_VALUE = 1
const MAX_STATE_VALUE = 2
const MIN_MOVEMENT_AGGRESSION = 0
const MAX_MOVEMENT_AGGRESSION = 5

var lifespan # Parameter is in terms of seconds.
var randomState
var movementAggression # Determines the magnitude in which the sunspot will move.

func _ready():
	lifespan = randi_range(LIFESPAN_MIN, LIFESPAN_MAX)
	randomState = randi_range(MIN_STATE_VALUE,MAX_STATE_VALUE)
	movementAggression = randi_range(MIN_MOVEMENT_AGGRESSION,MAX_MOVEMENT_AGGRESSION)
	self.modulate.a = 0
	while (self.modulate.a < .5):
		self.modulate.a += 0.01
		await $Timer.timeout
	match randomState:
		1:
			state1()
		2:
			state2()
		3:
			state1()

func modulateOverLifespan(_lifespan):
	var x = 0
	var _function = -1* (x-1)^2 + 1
	pass

func state1():
	var i: float = 0
	while i < lifespan * 20:
		self.position.x += sin(i / (25 - movementAggression))
		self.position.y += cos((i / (20 - movementAggression) + 5))
		await $Timer.timeout
		i += 1
	while (self.modulate.a > 0):
		self.modulate.a -= 0.02
		await $Timer.timeout
	queue_free()

func state2():
	var i: float = 0
	while i < lifespan * 20:
		self.position.x -= cos(i / (22 - movementAggression))
		self.position.y -= sin((i / (18 - movementAggression)) - 6)
		await $Timer.timeout
		i += 1
	while (self.modulate.a > 0):
		self.modulate.a -= 0.02
		await $Timer.timeout
	queue_free()

func state3():
	pass
	
func state4():
	pass
