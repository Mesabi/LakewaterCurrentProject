extends Node2D


var damage = 0
var impact = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _set_Up_Self(dmg : float, motion : Vector2):
	damage = dmg
	impact = motion


func _on_Hurtbox_body_entered(body):
	#print(body)
	if(body.has_node("Health_System")):
		print("has health")
		body.get_node("Health_System").deductHealthAndKill(damage)
	
	
	if(body.is_in_group("TEST")):
		print("In test group")
		#body.damage()
	pass # Replace with function body.


func test():
	print("test success")
