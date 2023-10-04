extends Control # Script for HungerControl Node

@export var satiation : float = 100 # Value for hunger. 100 represents being full, and 0 represents starving
@export var idleRate : float = 0.05 # Rate that represents amount satiation decreases for existing in world.
@export var tempRate : float = 0 # Rate that represents rate at which satiation is changing due to hunger.
@export var foodRestore : float = 15 # Value that represents amount of satiation restored when you eat food.

func eat(): # Function called to increase satiation when you eat. Potential mechanic where eating too much could have a drawback?
	if satiation + foodRestore > 100:
		satiation = 100
		print("Satiation maxed out")
	else:
		satiation += foodRestore
		print("Satiation increased by {}".format(foodRestore))

func expend(value): # Immedeately decreases satiation by a specified amount.
	if satiation - value < 0:
		satiation = 0
		print("Satiation equals 0")
	else:
		satiation -= value
		print("Satiation decreased by {}".format(value))

func _on_button_pressed(): #Function tied to button node.
	eat() 

func _on_timer_timeout(): # Increments satiation value
	satiation = satiation - idleRate - tempRate
	$ProgressBar.value = satiation 
	$Label.text = str(satiation).substr(0,6) # Update label with new satiation value

func _on_object_food_food_eaten(): # Function called when object_food transmits food_eaten signal.
	eat() 
