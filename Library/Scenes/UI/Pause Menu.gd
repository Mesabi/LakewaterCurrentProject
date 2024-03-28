extends Control


@onready var menuButton = $Panel/Menu_Button

var is_paused = false: set = set_is_paused

var menuSelect = 0 #0 will do nothing


func _ready():
	#self.PROCESS_MODE_WHEN_PAUSED
	#menuButton.PROCESS_MODE_INHERIT
	visible = is_paused


func _unhandled_input(event):
	#this runs outside of game processes I think. I need to find the docs for this. 
	if(Input.is_action_just_pressed("Pause")):
		self.is_paused = !is_paused

func set_is_paused(value):
	is_paused = value
	get_tree().paused = is_paused
	visible = is_paused
	#Panel.PROCESS_MODE_WHEN_PAUSED
	print("pause")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(!is_paused):
		return
	else:
		pass



#func menuInput():
	#if(Input.is_action_just_pressed()):
		#return
	#pass
	
	
	

func menusOptionSelected():
	match menuSelect:
		0:# Do nothing.
			return
		1:#resume
			pass
		2:#options
			pass
		3:#TODO Reserved
			pass
		4:#Exit game
			pass






func _on_Button_button_down():
	self.is_paused = !is_paused
	pass # Replace with function body.


func _on_exit_button_button_down():
	print("test")
	pass # Replace with function body.
