extends Node2D
# Signal to be emitted by Object A
signal test_signal(test)
var test = 0
var a = true
#ok, so remember this for signals. 

#signals need to be manually connected in the Signals tab.
#we can use if statements to fix this for multiple objects




func _ready():
	pass  # Replace with function body if needed

func _process(delta):
	if(Input.is_action_just_pressed("TEST")):
		print("test")
		emit_test_signal()
		test = 2
		pass


func emit_test_signal():
	# This function will emit the test_signal
	emit_signal("test_signal", test)
