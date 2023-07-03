extends RigidBody2D


var speed = 3000
var lifeSpan = 500
var damage = 1
var myParent
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if(lifeSpan > 0):
		lifeSpan -= 1
	else:
		queue_free()
	

	pass
	


func _on_Gatling_Bullet_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body.is_in_group("Valid_Bullet_Target"):
		print("hits!")
	pass # Replace with function body.


func _on_Gatling_Bullet_body_entered(body):
	print(body)
	if body.is_in_group("Valid_Bullet_Target"):
		print("hitss!")
	pass # Replace with function body.


func _on_DamageZone_body_entered(body):
	#THIS IS THE ONE THAT WORKS
	if body.is_in_group("Valid_Bullet_Target"):
		if(body.is_in_group("Has_Health")):
			body.get_node("Health_System").deductHealthAndKill(damage)
	queue_free()
	pass # Replace with function body.
