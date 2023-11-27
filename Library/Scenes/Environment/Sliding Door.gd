extends Node2D
#todo fix collision / crunch code. 
@onready var closedBot = $Waypoints/ClosedBot
@onready var openBot = $Waypoints/OpenBot
@onready var bot = $DoorBot

@onready var top = $Top

var doMove = true#change this to move the doors. 
var isOpen = false
var atDesiredState = false
var rot

# Called when the node enters the scene tree for the first time.
func _ready():
	rot = self.rotation
	pass # Replace with function body.

func _process(delta):
	if(Input.is_action_just_pressed("TEST")):
		doMove = !doMove
	
	
	if(doMove):
		var collideT
		var collideB
		if(!isOpen):
			collideB = bot.move_and_collide(Vector2.DOWN.rotated(rot))
			collideT = top.move_and_collide(Vector2.UP.rotated(rot))
		else:
			collideB = bot.move_and_collide(Vector2.UP.rotated(rot))
			collideT = top.move_and_collide(Vector2.DOWN.rotated(rot))
		if(collideT != null):
			handleCollision(collideT)
		if(collideB != null):
			handleCollision(collideB)
		


func _on_OpenBot_body_entered(body):
	if(body.is_in_group("doorSignalInternal")):
		isOpen = true
		atDesiredStateTest()
	pass # Replace with function body.


func _on_ClosedBot_body_entered(body):
	if(body.is_in_group("doorSignalInternal")):
		isOpen = false
		atDesiredStateTest()
	pass # Replace with function body.


func atDesiredStateTest():
	if(isOpen == atDesiredState):
		doMove = !doMove
	else:
		doMove = !doMove
		
		
func handleCollision(collide):
	#needs fixing.
	var Colliding_Object = collide.get_collider()
	var collision_normal = collide.get_normal()

	if(Colliding_Object.is_in_group("Player")):
		Colliding_Object.get_parent().pushPlayer(Vector2.RIGHT.rotated(rot) * 2000)
		Colliding_Object.get_parent().harmSelf(100)

	if(Colliding_Object.is_in_group("Has_Health")):
			Colliding_Object.get_node("Health_System").deductHealthAndKill(1000)
		#velocity = velocity * .9

	
	pass

