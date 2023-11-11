extends Node2D
#not entirely what I was using this for. Might be for global functions that I wasn't sure
#belonged in global? take better notes damnit! <.<



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func get_this_child(obj, name):
	#this needs testing but should work in principle. 
	#the fuck was I using this for?!?
	var exit = get_node(obj)
	if (exit.name == name):
		return exit

