extends KinematicBody2D

###INPUTS###
var oldMotion = Vector2()
var activeR = false
var activeL = false
var activeJ = false
var activeD = false#down
var activeI = false#interact
var activeA = false#attack
	
var activeDash = false
	#
var isJump = false
var isDash = false

var speed = 750
var velocity : Vector2
var gravity = 32
var jump = 20
var motion = Vector2.ZERO#probably should rename this to velocity for consistency. 
export var jumpforce = 400 # The jump force of the character
export var jumpLength = .5
var jumpTime = 0


var canDash = true
var dashCooldown = 2.0  # Adjust the cooldown time as needed (in seconds)
var dashForce = 1000
var dashLength = .5
var dashTime = 0.0

var attackLength = .5
var attackTime = 0.0


var multiJumps = 3
var currentJumps = 0



var xVel = 0
var yVel = 0


onready var stillAttack = preload("res://Library/Scenes/Player/Weapon/Sword/StillAttack.tscn")
var thisAttack = null

onready var attackPosL = $Attack/AttackPosLeft
onready var attackPosR = $Attack/AttackPosRight


onready var cam = $CanvasLayer/Camera2D
onready var label1 = $CanvasLayer/Camera2D/Label1
onready var label2 = $CanvasLayer/Camera2D/Label2
onready var label3 = $CanvasLayer/Camera2D/Label3
onready var facing = $sprite/facing

var interactResource = null
var interactAction = null
#onready var anim = $Autumn/AnimationPlayer
#onready var currenAnim = anim.get("parameters/playback")
var state = "idle"

# Called when the node enters the scene tree for the first time.
func _ready():
	print(self.position)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	label1.text = "x : "+String(motion.x) + "y : " + String(motion.y)
	label2.text = String(dashTime)
	label3.text = String(state)

	#velocity = Vector2.ZERO
	cam.position = self.position
	getInput(delta)
	move(delta)
	pass

func getInput(delta):
	#at some point this needs to be set up for non-play scenarios. i.e. menus
#	oldMotion = motion
	activeR = false
	activeL = false
	activeJ = false
	activeD = false#down
	activeI = false#interact
	
	activeDash = false
	#
	isJump = false
	isDash = false
	
###Input Map
	if Input.is_action_just_pressed("TEST"):
		thisAttack = stillAttack.instance()
		thisAttack.global_position = attackPosL.global_position#change to attackpos later
		thisAttack.test()
	#current issue is it's doing that thing where GP.self =/= GP.spawn
	#might not be an issue as the attacks will fade quickly.
	#also, wasn't this an order thing? might need to put pos in a different order of operations.
		get_parent().add_child(thisAttack)
		
	#old code for refrence...
#	var thisBullet = bullet.instance()
#	thisBullet.position = firepoint
#	thisBullet.rotation_degrees = self.rotation_degrees
#	thisBullet.apply_impulse(Vector2(), Vector2(bullet_speed, 0).rotated(rotation))
#	#consider changing this when UI is added to get_root
#	get_parent().add_child(thisBullet)
	if Input.is_action_pressed("reset"): # If the player enters the right arrow
		#Global.loadLevel(Global.getWorldManager(), "res://Library/Levels/Test_Managers_Level.tscn")
		print("reset")
	if Input.is_action_pressed("ui_right"): # If the player enters the right arrow
		activeR = true
	if Input.is_action_pressed("ui_left"): # If the player enters the left arrow
		activeL = true
	if Input.is_action_pressed("ui_down"): # If the player enters the left arrow
		activeD = true
	if Input.is_action_pressed("attack"): # If the player enters the left arrow
		activeA = true
	if Input.is_action_pressed("interact"):
		activeI = true
		#interact will need to pull from global.
		#additionally, need a "flick interact" and a "stop interact" state
		doInteract()
		
	if Input.is_action_just_pressed("ui_up"): # And the player hits the up arrow key
		##consider making this work with ActiveJ variable.
		if(currentJumps < multiJumps):
			jumpTime = jumpLength
			currentJumps += 1
			isJump = true
	if is_on_floor(): # If the ground checker is colliding with the ground
		currentJumps = 0#reset jumps
		if(!canDash):#reset dashes
			pass
	if Input.is_action_pressed("dash"):
		if(canDash):
			isDash = true
			dashTime = dashLength
			
	
		
		
		
	if(!activeR && !activeL): # If none of these are pressed
		motion.x = lerp(motion.x, 0, 0.1) # set the x to 0 by smoothly transitioning by 0.25


	#resetDash(delta)
func move(delta):
	####Movement State machine. works ok, needs more "crunch"
	#consider run speed slowly picking up?
	#idle / runL / runR / jumpL / jumpR / duck / attackstates
	match state:
		"idle":
			#drift to stop.
			if(abs(motion.x) > 10):
				motion *= .8
			else:
				 motion.x = 0
			stateIdle()
		"interact":
			stateInteract(activeI)
		"runL":
			motion.x = -speed # then the x coordinates of the vector be negative
			stateRunL()
		"runR":
			motion.x = speed # then the x coordinates of the vector be positive
			stateRunR()
		"slideL":
			motion.x = -speed * 1.5
			stateSlideL()
		"slideR":
			motion.x = speed * 1.5
			stateSlideR()
		"jumpL":
			jumpTime -= delta
			motion.x = -speed
			motion.y = -jumpforce
			stateJumpL()
		"jumpR":
			jumpTime -= delta
			motion.x = speed
			motion.y = -jumpforce
			stateJumpR()
		"fallL":
			motion.x = -speed
			stateFallL()
		"fallR":
			motion.x = speed
			stateFallR()
		"fallN":
			motion.x = lerp(motion.x, 0, 0.01)
			#no modification to vectors
			stateFallN()
		"jumpN":
			#consider modifying this to have more interactions with dash mechanics.
			#as is, this creates a a hard stop.
			jumpTime -= delta
			motion.y = -jumpforce
			motion.x = lerp(motion.x, 0, 0.001)
			stateJumpN()
		"dashR":
			dashTime -= delta
			motion.y = 0
			motion.x = dashForce
			stateDashR()
		"dashL":
			dashTime -= delta
			motion.y = 0
			motion.x = -dashForce
			stateDashL()
		"stopRunL":
			motion.x = lerp(motion.x, 0, 0.1)
			stateStopRunL()
		"stopRunR":
			motion.x = lerp(motion.x, 0, 0.1)
			stateStopRunR()
			
			
			
			
	motion.y += gravity + delta # Always make the player fall down
	motion = move_and_slide(motion, Vector2.UP)#move and slide is better for platformers. add hit boxes elsewhere.
	handleAttack()
	# Move and slide is a function which allows the kinematic body to detect
	# collisions and move accordingly

func stateIdle():
	if(isJump):
			state = "jumpN"
	if(activeR && !activeL):#idle -> runR
		state = "runR"
		if(isDash):
			state = "dashR"
	if(activeL && !activeR):#idle -> runL
		state = "runL"
		if(isDash):
			state = "dashL"
			
			
func stateInteract(activeI):
	#if can interact do: state == interact.
	if(Global.inInteraction):
		state = "interact"
	else:
		state = "idle"
	
	
	
	
func stateRunR():
	if(state == "runR"):
		if !is_on_floor():
			state = "fallR"
			return
		if(isJump):
			state = "jumpR"
		elif(isDash):
			state = "dashR"
		else:
			if(activeR):#runR -> runR
				if(activeD):#runR -> slideR
					state = "slideR"
				else:
					state = "runR"
			else:
				state = "stopRunR"
				if(isJump):
					state = "jumpR"

func stateRunL():

	if(state == "runL"):
		if !is_on_floor():
			state = "fallL"
			return
		if(isJump):
			state = "jumpL"
		elif(isDash):
			state = "dashL"
		else:
			if(activeL):#runR -> runR
				if(activeD):#runR -> slideR
					state = "slideL"
				else:
					state = "runL"
			else:
				state = "stopRunL"
				if(isJump):
					state = "jumpL"

func stateDashR():
	if(state == "dashR"):
		#if you hit a wall, immediately stop.
		if(is_on_wall()):
			state = "fallR"
		else:
			if(dashTime < 0):#if not still dashing go to run
				state = "runR"
		if(isJump):
			state = "jumpR"
			if(activeL):
				state = "jumpL"
			

func stateDashL():
	if(state == "dashL"):
		#if you hit a wall, immediately stop.
		if(is_on_wall()):
			state = "fallL"
		else:
			if(dashTime < 0):#if not still dashing go to run
				state = "runL"
		if(isJump):
			state = "jumpR"
			if(activeL):
				state = "jumpL"



func stateAttackR():
	pass



func stateAttackL():
	pass




func stateSlideR():
	if(state == "slideR"):
		if(activeR):#runR -> runR
			state = "slideR"
		else:
			state = "runR"
	else:
		state == "slideR"


func stateSlideL():
	if(state == "slideL"):
		#todo add slide time.
		
		if(activeL):#runR -> runR
			state = "slideL"
		else:
			state = "runL"

func stateJumpN():
	if(state == "jumpN"):
		if(jumpTime > 0):#
			if(activeL):#runR -> runR
				state = "jumpL"
			elif(activeR):
				state = "jumpR"
			else:
				state = "jumpN"
		else:
			if(activeL):#runR -> runR
				state = "fallL"
			elif(activeR):
				state = "fallR"
			else:
				state = "fallN"

	
func stateJumpR():
	if(state == "jumpR"):
		if(jumpTime > 0):
			if(activeL):#runR -> runR
				state = "jumpL"
			elif(activeR):
				state = "jumpR"
			else:
				state = "jumpN"
		else:
			if(activeL):#runR -> runR
				state = "fallL"
			else:
				state = "fallR"

func stateJumpL():
	if(state == "jumpL"):
		if(jumpTime > 0):
			if(activeR):#runR -> runR
				state = "jumpR"
			elif(activeL):
				state = "jumpL"
			else:
				state = "jumpN"
		else:
			if(activeR):#runR -> runR
				state = "fallR"
			else:
				state = "fallL"


func stateFallN():
	if(state == "fallN"):
		if is_on_floor():
			if(activeL):#runR -> runR
				state = "runL"
			elif(activeR):
					state = "runR"
			else:
				state = "idle"
		else:
			if(isJump):
				if(activeR):#runR -> runR
					state = "jumpR"
				elif(activeL):
					state = "jumpL"
				else:
					state = "jumpN"
			else:
				if(activeR):#runR -> runR
					state = "fallR"
				elif(activeL):
					state = "fallL"
				else:
					state = "fallN"

	
	
	
func stateFallR():
	if(state == "fallR"):
		if is_on_floor():
			if(activeR):#runR -> runR
				state = "runR"
			else:
				if(activeL):
					state = "runL"
				else:
					state = "idle"
		else:
			if(isJump):
				if(activeL):#runR -> runR
					state = "jumpL"
				else:
					state = "jumpR"
			else:
				if(activeL):#runR -> runR
					state = "fallL"
				else:
					state = "fallR"


func stateFallL():
	if(state == "fallL"):
		if is_on_floor():
			if(activeL):#runR -> runR
				state = "runL"
			elif(activeR):
					state = "runR"
			else:
				state = "idle"
		else:
			if(isJump):
				if(activeR):#runR -> runR
					state = "jumpR"
				else:
					state = "jumpL"
			else:
				if(activeR):#runR -> runR
					state = "fallR"
				else:
					state = "fallL"
	

func stateStopRunR():
	if(state == "stopRunR"):
		if(activeR):#runR -> runR
			state = "runR"
			if(activeD):#runR -> slideR
				state = "slideR"
		else:
			state = "idle"
	
func stateStopRunL():
	if(state == "stopRunL"):
		if(activeL):#runR -> runR
			state = "runL"
		if(activeR):#runR -> slideR
				state = "slideL"
		else:
			state = "idle"

func handleAttack():
	#attackStill(L/R) / attackMove(L/R) / attackUp(L/R) /attackDash(L/R) attackDown(L/R)
	if(!activeA):
		return
	else:
		match(state):
			"idle":
				state = "attackStllN"#fix direction later
			"interact":
				return
			"runL":
				state = "attackMoveL"
			"runR":
				state = "attackMoveR"
			"slideL":#sliding will move player faster, but can't attack.
				return
			"slideR":
				return
			"jumpL":
				state = "attackUpL"
			"jumpR":
				state = "attackMoveR"
			"fallL":
				state = "attackDownL"
			"fallR":
				state = "attackDownR"
			"fallN":####
				return##
			"jumpN":####Neutrals need fixing.
				return#
			"dashR":####
				state = "attackDashL"
			"dashL":
				state = "attackDashL"
			"stopRunL":
				state = "attackStillL"
			"stopRunR":
				state = "attackStillR"
		
func returnFromAttack():
	pass





func adustFacing():
	#fix later
	if(motion.x == 0):
		pass
	elif(motion.x > 0):
		facing.rotation_degrees = 0
	else:
		facing.rotation_degrees = 180
	



func get_Input(delta):
	#old do not use
	if(Input.is_action_just_pressed("Pause")):
		pass
#	if(Input.is_action_just_pressed("Inventory")):
#		pass
	if(Input.is_action_just_pressed("TEST")):
		#print(get_tree().get_root().get_node("Main").get_child(0).get_node("WorldManager").get_node("Player").global_position)
		#Global.loadLevel(self, "res://Library/Levels/Test_Level.tscn")
		#UI.currentHealth.text = "Asdf"
		print("TEST")
		#var dlog = load("res://Library/Scenes_2/test1.tres")
		#DialogueManager.show_example_dialogue_balloon("this_is_a_node_title", dlog)
		#print(player.velocity)
		#print(Global.inInteraction)
	
	if(Input.is_action_just_pressed("click")):
		#print("mouse")
		#print(get_global_mouse_position())
		#print("player")
		#print(player.global_position)
		#print(get_global_mouse_position().distance_to(player.global_position))
		pass
	
	if(Input.is_action_just_pressed("interact")):#change to "switch weapon" also add hot keys.
		pass
	if(Input.is_action_just_pressed("reload")):

		pass
	if(Input.is_action_just_pressed("toggle")):
		pass
	if(Input.is_action_pressed("fire_weapon")):
		pass
	
	
		
func test():
	print(self)
		
func setInteract(r, a):
	interactResource = r
	interactAction = a

		
func doInteract():
	Global.doConversation(interactResource,interactAction)
	state = "interact"

		
func takeDamage():
	pass
































		
		
		




func _on_AreaRight_body_entered(body):
	#not in use
	print(body)
	pass # Replace with function body.


func _on_AreaLeft_body_entered(body):
		#not in use
	print(body)
	pass # Replace with function body.
