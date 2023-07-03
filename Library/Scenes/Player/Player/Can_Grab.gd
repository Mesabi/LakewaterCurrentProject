extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var canGrab = true
var isGrabbing = false
onready var mySprite = $Sprite


func returnStatus():
	return isGrabbing
	
	
func setStatus(status):
	isGrabbing = status
	mySprite.modulate = Color(1,0,1)
