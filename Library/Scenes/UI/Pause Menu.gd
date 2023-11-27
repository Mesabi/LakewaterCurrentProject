extends Control


var is_paused = false: set = set_is_paused


func _ready():
	visible = is_paused


# Called when the node enters the scene tree for the first time.
func _unhandled_input(event):
	#this runs outside of game processes I think. I need to find the docs for this. 
	if(Input.is_action_just_pressed("Pause")):
		self.is_paused = !is_paused

func set_is_paused(value):
	is_paused = value
	get_tree().paused = is_paused
	visible = is_paused
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_button_down():
	self.is_paused = !is_paused
	pass # Replace with function body.
