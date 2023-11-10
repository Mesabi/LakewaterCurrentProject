extends Node2D
#dialog hook exists to store the path and information data to a dialog object.

export var myHook = "this_is_a_node_title"#this_is_a_node_title is the default title
export var myPath = ""

func returnPath():
	return myPath
	
func returnHook():
	return myHook
	
func updateHook(hook):
	#find a way to set this up with state variables in dialog.
	myHook = hook
