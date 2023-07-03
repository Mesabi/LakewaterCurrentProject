extends Node2D


onready var segment = preload("res://Library/Scenes/Player/Weapon/Beam Segment.tscn")


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(Input.is_action_just_pressed("TEST")):
		instanceSegment(Vector2(0, 0), 10)
	pass



func instanceSegment(var pos, var times):
	print(times)
	var next = segment.instance()
	times = times - 1
	next.position = pos
	add_child(next)
	if(times > 0):
		instanceSegment(pos + Vector2(10, 0), times)
	pass
#	add_child()
