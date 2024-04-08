extends Control
#currently this refuses to allow buttons to be pressed on pause.
#It doesn't seem tied to the parent. It was moved WM -> Main
#only has this issue when actual game is running....

var debug = false
@onready var debugLabel = $DebugLabel

#@onready var menuButton = $Panel/Menu_Button
@onready var resumeButton = $Panel/Org/Resume
@onready var tSprite = $Sprite2D

var is_paused = false: set = set_is_paused

var menuSelect = 0 #0 will do nothing


func _ready():
	#self.PROCESS_MODE_WHEN_PAUSED
	#menuButton.PROCESS_MODE_INHERIT
	visible = is_paused
	pass


func _unhandled_input(event):
	#this runs outside of game processes
	if(Input.is_action_just_pressed("Pause")):
		is_paused = !is_paused
		pass
		

func set_is_paused(value):
	is_paused = value
	get_tree().paused = is_paused
	grab_click_focus()
	visible = is_paused
	#Panel.PROCESS_MODE_WHEN_PAUSED
	print(has_focus())
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	debugLabel.text = str(get_global_mouse_position())
	if(debug):
		tSprite.color = Global.colorTest
	if(is_paused):
		pass
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


func _on_area_2d_mouse_entered():
	tSprite.color = Color.REBECCA_PURPLE
	print("asd")
	pass # Replace with function body.
