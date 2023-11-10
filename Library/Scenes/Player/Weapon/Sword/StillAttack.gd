extends Node2D


var damage = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Hurtbox_body_entered(body):
	if(body.is_in_group("TEST")):
		print("deez nuts")
		#body.damage()
	pass # Replace with function body.


func test():
	print("test success")
