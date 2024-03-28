extends Node2D

@export var debug = false
@export var checkpoint : String 
#for YOUR own sanity, these will need standardized naming!
###NOTE#: Go like this: #level_area_##

@onready var sprite = $Sprite2D
@onready var label = $Label
@onready var marker = $Marker2D
# Called when the node enters the scene tree for the first time.
func _ready():
	label.visible = Global.getdebug()
	if(label.visible):
		label.text = checkpoint
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
