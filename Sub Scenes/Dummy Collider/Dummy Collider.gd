extends Node2D

# Testing lambda functions
var my_lambda1 = func ():
	print("calling1")
var my_lambda2 = func ():
	print("calling2")

var lambdaArray = [my_lambda1, my_lambda2]

func function_caller(x:Callable):
	x.call()
func print_hello():
	print("hello")
func _ready():
	lambdaArray[0].call()
	#function_caller(Callable("print_hello"))
