extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var firepoint = $firepoint
onready var gatling = $Gatling_Gun

# Called when the node enters the scene tree for the first time.
func _ready():

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var rotate = self.rotation
	if(Input.is_action_pressed("TEST")):
		gatling.shoot(rotation, firepoint.global_position)
	pass
