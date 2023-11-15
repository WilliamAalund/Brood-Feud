extends TextureProgressBar

const STOMACH_BAR_LOWEST_VISIBLE_VALUE = 22.5
const STOMACH_VAR_HIGHEST_VISIBLE_VALUE = 68

const STOMACH_BAR_RANGE = STOMACH_VAR_HIGHEST_VISIBLE_VALUE - STOMACH_BAR_LOWEST_VISIBLE_VALUE

var hungerValue = 100

func _ready():
	updateValue()
	
func _process(_delta):
	updateValue()

func updateValue():
	self.value = STOMACH_BAR_LOWEST_VISIBLE_VALUE + hungerValue * (STOMACH_BAR_RANGE / 100)


