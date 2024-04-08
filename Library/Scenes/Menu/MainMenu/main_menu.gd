extends Control

@onready var options = preload("res://Library/Scenes/Menu/MainMenu/options_menu.tscn")
@onready var select = preload("res://Library/Scenes/Menu/MainMenu/level_select.tscn")
#will probably need to update this path later.


func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_pressed():
	#Global.loadLevel(wm, "res://Library/Levels/GD4Test-01.tscn")#res://Library/Levels/test-movement.tscn
	Global.startUp()
	#print(get_parent().get_child(0))#.readFile
	removeSelf()
	pass # Replace with function body.


func _on_options_pressed():
	var Option = options.instantiate()
	add_child(Option)
	pass # Replace with function body.


func _on_extras_pressed():
	var Select = select.instantiate()
	add_child(Select)
	pass # Replace with function body.


func _on_exit_pressed():
	get_tree().quit()
	pass # Replace with function body.


func removeSelf():
	#keeping this like this for anything else I need to add.
	self.queue_free()
