extends KinematicBody2D

###Current ISSUE!!!!
#need a reset if the lunge mechanic stops working!
onready var lunge = preload("res://Library/Scenes/Enemy/Lunge Token.tscn")
#onready var makeTimer = preload("res://Library/Scenes/Timer.tscn")
onready var multiTimer = $MultiTimer
#1 attack run times
#2 pause after attack run / hit
#3 lunge token timeout
#4 


onready var health = $Health_System
var speed = 10
var damage = 10
var velocity = Vector2()
var state = "idle"
var timer = 100 

var fearCounter = 0
var IamAfraidOfThis : Vector2

var attacking = false
var reachedSnapback = true
var justAttacked = false
var justSuccessfulAttack = false
var attackboost = 0
var attackCooldown = 0
var target
var snapback

var repeatedCollisions = 0


onready var label = $Test_State
onready var label2 = $Label_2
onready var ass = $Face_Sprite/Ass


# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass


func _physics_process(delta):
	beLessAfraid()
	beAlive()
	isAfraid()
	resetBoolWithTimers()
	var collide = move_and_collide(velocity * delta)
	if collide:
		handleCollision(collide)
		repeatedCollisions += 1
		#create block for player and nonplayer
	if(false):
		if(repeatedCollisions < 5):
			hitPlayer(collide.collider)
		else:
			handleCollisionLock()
	else:
		if(repeatedCollisions > 0):
			repeatedCollisions -= 1

	batStateMachine(delta)
	if(Input.is_action_just_pressed("TEST")):
		pass
		#print(self)

func getPlayerPos():
	#returns global location of the player
	return get_node("/root/Main/WorldManager/Player").global_position

func findPlayer():
	#returns a vector towards the player.
	return self.global_position.direction_to(get_node("/root/Main/WorldManager/Player").global_position)

func howCloseToPlayer():
	#returns the distance to the player
	return self.global_position.distance_to(get_node("/root/Main/WorldManager/Player").global_position)

func setRepeatedCollisionsHigher(amt):
	repeatedCollisions += amt

func handleCollisionLock():
	state = "retreat"


func batStateMachine(delta):
	label.text = state
	label2.text = "timers" + String(multiTimer.cooldownOne.wait_time)
	#label.text = String(repeatedCollisions)
	match state:
		"idle":
			doIdle(delta)
		"wander":
			pass
		"patrol":
			pass
		"search":
			pass
		"chase":
			doChase(delta)
		"hostile":
			doHostile(delta)
		"retreat":
			doRetreat()
		"stunned":
			doStunned(delta)
		_:
			pass

func doWander(delta):
	#wander behavior is going to be contextual to environment.
	#fix later
	pass

func doIdle(delta):
	checkIfPlayerNear()
	velocity = Vector2.ZERO
	
func doPatrol(delta):
		#wander behavior is going to be contextual to environment.
	#fix later
	pass	

func doSearch(delta):
	pass
	
func doChase(delta):
	#chase the player until it leaves range.
	facePlayer()
	velocity = findPlayer() * 100
	checkForDisengage()
	checkForAttackRun()
	if(repeatedCollisions > 0):
		repeatedCollisions -= 1
	pass
	
func doHostile(delta):
	if(justAttacked):
		#can't attack
		
		#code for it holding distance.
		pass
	else:
		#can attack
		if(!attacking):
			#need to set up attack run
			setAttackRun(delta)
		else:
			doAttack(delta)
	

func doRetreat():
	#reverses the bat immediately away from the player / thing shooting bullets (add that later)

	if(fearCounter > 10):
		
		velocity =  self.global_position.direction_to(IamAfraidOfThis) * -20 * speed
	else:
		state = "chase"

	
func doStunned(delta):
	velocity = getPlayerPos() * -.5
	if(justSuccessfulAttack):
		multiTimer.set_timer_Two(2)
		justSuccessfulAttack = false
	else:
		if(!multiTimer.cooldownTwoActive):
			state = "chase"


func resetBoolWithTimers():
	attacking = multiTimer.cooldownOneActive
	justAttacked = multiTimer.cooldownTwoActive


func isAfraid():
	if(fearCounter > 5):
		state = "retreat"
	


func checkIfPlayerNear():
	#if the player gets within this range, the bat will start chasing.
	
	if(howCloseToPlayer() < 300):
		if(state != "hostile"):
			state = "chase"
	else:
		state = "idle"

func checkForAttackRun():
	if(howCloseToPlayer() < 100):
		state = "hostile"

func checkForDisengage():
	if(howCloseToPlayer() > 800):
		state = "idle"

func setAttackRun(delta):
		#first instance sets this up.
		attacking = true
		if(target == null):
			target = lunge.instance()
		#snapback = lunge.instance()
	
		target.global_position = changePositionRandomly(getPlayerPos(), 25)
		#snapback.global_position = self.global_position
		multiTimer.set_timer_One(2)
		multiTimer.set_timer_Three(5)
		get_tree().get_root().add_child(target)
		#get_tree().get_root().add_child(snapback)
		


func doAttack(delta):

	if(target!=null):
	#race towards the target...
		if(self.global_position.distance_to(target.global_position)> 5):
			#...if the target is far away
			velocity = self.global_position.direction_to(target.global_position) * 800
		else:
			#erase the target because you're closer than 5
			target.queue_free()
			target = null
			#reachedSnapback = false
		if(!multiTimer.cooldownThreeActive):#when this is false, this should wipe the target as well.
			target.queue_free()
			target = null
	else:
		attacking = false
		#snapback doesn't need to be used, instead we'll just reverse from the player's position.
	

func hitPlayer(colliding_object):
	if colliding_object.collider.is_in_group("Player"):
		if(target!=null):
			#clear the target if the attack is successful
			target.queue_free()
			target = null
		if(state != "stunned"):
			#should not be able to push or attack while stunned
			colliding_object.collider.get_parent().pushPlayer(velocity * .1)
			colliding_object.collider.get_parent().harmSelf(damage * (velocity.length() * .0002))
			justSuccessfulAttack = true
	if(state != "stunned"):
		state = "stunned"
		#attacking = false

	velocity = Vector2.ZERO


func _on_body_entered(body: PhysicsBody) -> void:
	if body is KinematicBody:
		print("body")

func handleCollision(collide):
	#needs fixing.
	var Colliding_Object = collide.get_collider()
	var collision_normal = collide.get_normal()

	if(Colliding_Object.is_in_group("TEST")):
		print("Object is in group test!!!")
	if(Colliding_Object.is_in_group("Repell")|| Colliding_Object.is_in_group("Player")):
		velocity = velocity.rotated(self.rotation-PI)* 10
		if(Colliding_Object.is_in_group("Player")):
			hitPlayer(collide)
	#make sure you account for infighting later
	if(Colliding_Object.is_in_group("Has_Health")):
			Colliding_Object.get_node("Health_System").deductHealthAndKill(damage)
		#velocity = velocity * .9

	
	pass


func facePlayer():
	self.look_at(getPlayerPos())

func dontFacePlayer():
	#fix later.
	ass.look_at(getPlayerPos())
	self.rotation = ass.rotation


func _on_Senses_area_entered(area):
	#print(area)
	pass # Replace with function body.


func _on_Senses_body_entered(body):
	if(body.is_in_group("Bullet")):
		fearCounter += 5
		IamAfraidOfThis = getPlayerPos()#body.myParent.global_position
	pass # Replace with function body.

func beLessAfraid():
	if(fearCounter > 0):
		fearCounter -= 1
	if(fearCounter == 0 && state == "retreat"):
		state = "idle"

func beAlive():
	if(health.isDead):
		print(self)
		queue_free()

func changePositionRandomly(position: Vector2, amt: float) -> Vector2:
	# Generate a random angle in radians
	var angle = rand_range(0, 2 * PI)
	
	# Calculate the direction vector
	var direction = Vector2(cos(angle), sin(angle))
	
	# Multiply the direction vector by the amount
	var displacement = direction * amt
	
	# Update the position by adding the displacement
	var newPosition = position + displacement
	
	return newPosition
