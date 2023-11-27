extends Node2D


@onready var currentLevel = $Current_Level
@onready var label = $Label
@onready var path = "res://Library/Levels/Test_Level.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	label.text = path
	changeLevel(path)
	pass # Replace with function body.





func changeLevel(level):
	currentLevel.queue_free()
	path = level
	var levelLoad = load("res://Library/Levels/Test_Level.tscn")
	currentLevel = levelLoad.instantiate()
	add_child(currentLevel)
