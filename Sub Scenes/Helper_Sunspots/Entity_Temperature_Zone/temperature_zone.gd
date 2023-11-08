extends Node2D

const LIFESPAN_MIN = 4
const LIFESPAN_MAX = 10

var lifespan = 5 # Parameter should be in terms of seconds.
var randomState = randi_range(1,3)

func _ready():
	lifespan = randi_range(LIFESPAN_MIN, LIFESPAN_MAX)
	self.modulate.a = 0
	while (self.modulate.a < .4):
		self.modulate.a += 0.01
		await $Timer.timeout
	match randomState:
		1:
			state1()
		2:
			state1()
		3:
			state1()

func modulateOverLifespan(_lifespan):
	var x = 0
	var _function = -1* (x-1)^2 + 1
	pass

func state1():
	var i: float = 0
	while i < lifespan * 20:
		self.position.x += sin(i / 25)
		self.position.y += cos((i / 20) + 5)
		await $Timer.timeout
		i += 1
	while (self.modulate.a > 0):
		self.modulate.a -= 0.02
		await $Timer.timeout
	queue_free()

func state2():
	pass

func state3():
	pass
	
func state4():
	pass
