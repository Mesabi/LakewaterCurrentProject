extends StaticBody2D


@onready var myShape = $CollisionShape2D

var open = false
var locked = false



# Called when the node enters the scene tree for the first time.
func _ready():
	setDoor()
	pass # Replace with function body.


func setDoor():
	#disabled == true: door is open
	myShape.disabled = open

func openDoor():
	open = true
	setDoor()

func closeDoor():
	open = false
	setDoor()
