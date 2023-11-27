extends Node2D

const ObjectA = preload("res://Library/Scenes/Environment/Test_Stuff/B.tscn")
@export var even = false
@export var myName = "" #set in editor
@export var num : int = 0 #set in editor

func _ready():
	# Connect to the test_signal of Object A
	var object_a = ObjectA.instantiate()  # Create a new instance of ObjectA
	object_a.connect("test_signal", Callable(self, "_on_B_test_signal"))
	print(myName)

func _on_B_test_signal(test):
	#print("Test signal received from Object A")
	if(test == num):
		print(myName)
		
	pass # Replace with function body.
