extends Node

# This file lists all important parameters that directly affect gameplay.
# This file is NOT a comprehensive list of constants.

# --- BIRD PARAMETERS ---
const LEVEL_UP_MOVE_SPEED_INCREASE = 10 # Increase in magnitude of velocity a bird recieves for aging up
const LEVEL_UP_PUSH_FORCE_INCREASE = 400 # Increase in force of pushing that a bird recieves for agine up
const FOOD_RESTORE = 12 # Amount of satiation a bird recieves upon eating a piece of food
const IDLE_SATIATION_DRAIN_RATE = 0.04 # Idle decrease in satiation that a bird takes simply for existing.
const SUN_RATE = -0.03 # Amount of satiation drain that bird loses for basking in sun

# --- PLAYER BIRD PARAMETERS ---
const STARTING_LEVEL = 0 
const PLAYER_EXPERIENCE_TO_LEVEL_UP = 4 # Default value is 4
const LEVEL_UP_SCALE_INCREASE = 0.2
const LEVEL_NEEDED_TO_CHANGE_SPRITE = 6
const LEVEL_NEEDED_TO_WIN_THE_GAME = 8
const PLAYER_BIRD_BLEED_RATE = 0.03
const BASE_STOMACH_CAPACITY = 3 # Default value is 3
const MAXIMUM_STOMACH_CAPACITY = 6
const INTERACT_INPUT_DELAY = 0.1 # In seconds
const INTERACT_LENGTH = 0.2 # In seconds
const INTERACT_COOLDOWN = 0.2 # In seconds

# --- AI BIRD PARAMETERS --- 
const AI_BIRD_EXPERIENCE_TO_LEVEL_UP = 3
const AI_BIRD_LEVEL_UP_SCALE_INCREASE = 0.1
const AI_BIRD_BLEED_RATE = 0.04
const MAXIMUM_FOOD_IN_TUMMY_ALLOWED = 2
const MAXIMUM_AGGRO_VALUE = 100
const AI_BIRD_INTERACT_INPUT_DELAY = 0.2 # In seconds
const AI_BIRD_INTERACT_LENGTH = 0.2 # In seconds
const AI_BIRD_INTERACT_COOLDOWN = 1.3 # In seconds

# --- MOMMA BIRD PARAMETERS ---
const SECONDS_TO_RETURN_TO_NEST = 25
const FOOD_PIECES_TO_DROP = 8
const FOOD_DROP_INTERVAL_IN_SECONDS = 1
const TIME_TO_LAND_IN_SECONDS = 1.5

# --- PREDATOR BIRD PARAMETERS --- 
# All of these parameters are in seconds
const BASE_TIME_AWAY_FROM_NEST = 55 # The base time that the predator will wait intil approaching the nest
const TIME_AWAY_STALL = 4 # The time that the predator will wait after attempting to approach, but being blocked by momma bird
const TIME_AWAY_VARIANCE = 5 # The maximum amount of variance in the time that the predator will wait to approach the nest
const TIME_APPROACHED_MIN = 2 # The minimum amount of time the predator will stay approached before heading to the nest
const TIME_APPROACHED_MAX = 4 # The maximum amount of time the predator will stay approached before heading to the nest
const TIME_APPROACHED_STALL = 4 # The time that the predator will wait after attempting to head to the nest, but was blocked by momma bird
const TIME_TO_STAY_AT_NEST = 3 # The time that the predator will stay inside of the nest before leaving
