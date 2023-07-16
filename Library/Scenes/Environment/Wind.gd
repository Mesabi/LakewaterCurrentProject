extends Area2D
#needs a shit ton of work

# Declare member variables here. Examples:
var rot

# Called when the node enters the scene tree for the first time.
func _ready():
	rot = self.rotation


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Wind_body_entered(body):
	if(body.is_in_group("Player")):
		body.get_parent().pushPlayer(Vector2.RIGHT.rotated(rot) * 20)
	
	pass # Replace with function body.
