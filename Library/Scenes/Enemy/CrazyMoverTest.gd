extends CharacterBody2D

var speed = 10
var damage = 10
var velocity = Vector2()
@onready var CrazyPath400 = preload("res://Library/Scenes/Enemy/Crazypath400.tscn")
var doingPath = false
var pathPos
var target
var step = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	doCrazyMove()
	var collide = move_and_collide(velocity * delta)


func doCrazyMove():
	if(!doingPath):
		generateCrazyPath()
	else:
		velocity = self.global_position.direction_to(target) * 100
		if(atTarget()):
			goToThisPoint(step)
			step += 1
		if(tooFarFromTarget()):
			print(target)
	
	
	
	
	
func generateCrazyPath():
	var path = CrazyPath400.instantiate()
	path.global_position = self.global_position
	self.get_parent().add_child(path)
	pathPos  = path.giveCrazyPath400()
	#path.queue_free()
	doingPath = true
	goToThisPoint(step)
	
func goToThisPoint(pt):
	if(pt < 8):
		target = pathPos[pt]

func atTarget():
	if(self.global_position.distance_to(target) < 10):
		return true
	else:
		return false

func tooFarFromTarget():
	if(self.global_position.distance_to(target) > 400):
		return true
	else:
		return false
