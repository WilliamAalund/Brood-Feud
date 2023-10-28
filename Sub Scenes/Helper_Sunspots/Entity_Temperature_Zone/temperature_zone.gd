extends Node2D

var randomState = randi_range(1,3)


func _ready():
	self.modulate.a = 0
	while (self.modulate.a < .5):
		self.modulate.a += 0.01
		await $Timer.timeout
	match randomState:
		1:
			state1()
		2:
			state1()
		3:
			state1()



func state1():
	var i: float = 0
	while i < 3000:
		self.position.x += sin(i / 25)
		self.position.y += cos((i / 20) + 5)
		await $Timer.timeout
		i += 1
	while (self.modulate.a > 0):
		self.modulate.a -= 0.01
		await $Timer.timeout
	queue_free()
