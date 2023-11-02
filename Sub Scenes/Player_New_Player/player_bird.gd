extends Node2D

var satiation = 100
var inSunlight = false

signal playerStarved

func _ready():
	$character_bird/debugger_satiation.text = str(satiation).substr(0,5)

func eat(): # Function called to increase satiation when you eat.
	if satiation + get_parent().foodRestore > 100:
		satiation = 100
	else:
		satiation += get_parent().foodRestore

func expend(value): # Immedeately decreases satiation by a specified amount.
	if satiation - value < 0:
		satiation = 0
		emit_signal("playerStarved")
	else:
		satiation -= value

func decrementSatiation(): # Decreases the bird's satiation value
	satiation = satiation - get_parent().idleSatiationDrainRate - get_parent().sunRate * int(inSunlight)
	$character_bird/debugger_satiation.text = str(satiation).substr(0,5)
	if satiation < 0:
		emit_signal("playerStarved")
		
# --- DETECTING EATING, DECREMENTING HUNGER ---
func _on_beak_area_area_entered(area):
	if area.is_in_group("food"):
		Input.start_joy_vibration(0, 0.5, 0.5, 0.1)
		eat()

func _on_bird_control_birds_increment_hunger():
	decrementSatiation()

# --- ENTERING, EXITING SUNLIGHT ---
func _on_body_area_area_entered(area):
	if area.is_in_group("sunray"):
		#print("I am in the sunlight")
		inSunlight = true

func _on_body_area_area_exited(area):
	if area.is_in_group("sunray"):
		#print("I am in the sunlight")
		inSunlight = false
