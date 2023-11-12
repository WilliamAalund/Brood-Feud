extends CharacterBody2D

@export var move_speed : float = 100
@export var push_force : float = 20

var satiation = 100
var inSunlight = false
var isExerting = false
const foodRestore = 10

const sunRate = -0.02

signal playerStarved

func _ready():
	$debugger_satiation.text = str(satiation).substr(0,5)

func _physics_process(_delta):
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	velocity = input_direction * move_speed
	move_and_slide()
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody2D:
			print(-c.get_normal() * push_force)
			#-c.get_normal() * push_force
			c.get_collider().apply_force(c.get_normal() * -push_force)
	
# --- SATIATION FUNCTIONS ---
func eat(): # Function called to increase satiation when you eat.
	if satiation + foodRestore > 100:
		satiation = 100
		print("Satiation: maxed out")
	else:
		satiation += foodRestore
		#print("Satiation: increased by {}".format(foodRestore))
		
func expend(value): # Immedeately decreases satiation by a specified amount.
	if satiation - value < 0:
		satiation = 0
		print("Satiation: equals 0")
	else:
		satiation -= value
		print("Satiation: decreased by {}".format(value))
func decrementSatiation(): # Decreases the bird's satiation value
	satiation = satiation - get_parent().idleSatiationDrainRate - sunRate * int(inSunlight)
	$debugger_satiation.text = str(satiation).substr(0,5)
	if satiation < 0:
		emit_signal("playerStarved")

# --- DETECTING EATING, INCREMENTING HUNGER ---
func _on_beak_area_area_entered(area):
	if area.is_in_group("food") or area.is_in_group("playerfood"):
		eat()

func _on_bird_control_birds_increment_hunger():
	decrementSatiation()

# --- ENTERING, EXITING SUNLIGHT ---
func _on_area_2d_area_entered(area):
	if area.is_in_group("sunray"):
		#print("I am in the sunlight")
		inSunlight = true

func _on_area_2d_area_exited(area):
	if area.is_in_group("sunray"):
		#print("I have left the sunlight")
		inSunlight = false

