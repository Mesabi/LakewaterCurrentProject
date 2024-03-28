extends Area2D
###THIS IS THE ONE THAT WORKS
#Interact must be attached to an object that also has a dialog_hook
@export var doForceInteract = false
#rethink this var... export var removeAfterInteract = false #this will only work if Interact is forced.
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

@export var myHook = "this_is_a_node_title"#this_is_a_node_title is the default title
@export var myPath = ""


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Interact_body_entered(body):
	#gives the player the ability to interact.
	#print(body)
	if(body.is_in_group("Player")):
		#calls the hook and the path properties from the dialogHook
		body.setInteract(getPath(), getHook())
		#This only gives the player the option to interact. It does not force an interaction.
		if(doForceInteract):
			body.doInteract()
	pass # Replace with function body.



func getHook():
	return myHook
	#return self.get_parent().get_node("Dialog_Hook").returnHook()
	
func getPath():
	return myPath
#	return self.get_parent().get_node("Dialog_Hook").returnPath()


func returnPath():
	return myPath
	
func returnHook():
	return myHook
	
func updateHook(hook):
	#find a way to set this up with state variables in dialog.
	myHook = hook




func _on_Interact_body_exited(body):
	#removes this from the player
	if(body.is_in_group("Player")):
		#print(body)
		body.setInteract(null, null)
		Global.inInteraction = false#resets this after the player moves away.
	pass # Replace with function body.


