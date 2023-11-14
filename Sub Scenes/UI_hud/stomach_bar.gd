extends TextureProgressBar

const STOMACH_BAR_LOWEST_VISIBLE_VALUE = 22.9
const STOMACH_VAR_HIGHEST_VISIBLE_VALUE = 82.3
const STOMACH_BAR_RANGE = STOMACH_VAR_HIGHEST_VISIBLE_VALUE - STOMACH_BAR_LOWEST_VISIBLE_VALUE

var actualValue = 100

func _ready():
	updateValue()
	
func _process(_delta):
	updateValue()

func updateValue():
	self.value = STOMACH_BAR_LOWEST_VISIBLE_VALUE + actualValue * (STOMACH_BAR_RANGE / 100)


