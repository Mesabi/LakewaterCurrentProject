extends CharacterBody2D






########Movement

# Declare member variables here. Examples:
var speed = 500
var velocity : Vector2
var gravity = 32
var jump = 20
var motion = Vector2.ZERO#probably should rename this to velocity for consistency. 
@export var jumpforce = 400 # The jump force of the character
@export var jumpLength = .5
var jumpTime = 0


var canDash = true
var dashCooldown = 2.0  # Adjust the cooldown time as needed (in seconds)
var dashForce = 1000
var dashLength = .5
var dashTime = 0.0

var multiJumps = 3
var currentJumps = 0



var xVel = 0
var yVel = 0




@onready var cam = $CanvasLayer/Camera2D
@onready var label1 = $CanvasLayer/Camera2D/Label1
@onready var label2 = $CanvasLayer/Camera2D/Label2
@onready var label3 = $CanvasLayer/Camera2D/Label3
@onready var facing = $sprite/facing



var interactResource = ""
var interactAction = ""
#onready var anim = $Autumn/AnimationPlayer
#onready var currenAnim = anim.get("parameters/playback")
var state = "idle"#I should eventually change this to an enum. Holding off until all states are figured out.
#idle / runL / runR / jumpL / jumpR / duck / 

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.
#
#func _process(delta):
#	print("running")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	label1.text = "x : "+String(motion.x) + "y : " + String(motion.y)
	label2.text = String(dashTime)
	label3.text = String(state)

	#velocity = Vector2.ZERO
	cam.position = self.position
	# Input handling
	
	#moveCode(delta)
	testInput(delta)
	adustFacing()




func testInput(delta):
	var oldMotion = motion
	var activeR = false
	var activeL = false
	var activeJ = false
	var activeD = false#down
	var activeI = false#interact
	
	var activeDash = false
	#
	var isJump = false
	var isDash = false
	
	
###Input Map
	if Input.is_action_pressed("ui_right"): # If the player enters the right arrow
		activeR = true
	if Input.is_action_pressed("ui_left"): # If the player enters the left arrow
		activeL = true
	if Input.is_action_pressed("ui_down"): # If the player enters the left arrow
		activeD = true
	if Input.is_action_pressed("interact"):
		activeI = true
		#interact will need to pull from global.
		#additionally, need a "flick interact" and a "stop interact" state
		
	if Input.is_action_just_pressed("ui_up"): # And the player hits the up arrow key
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
	
	####Movement State machine. works ok, needs more "crunch"
	#idle / runL / runR / jumpL / jumpR / duck / 
	match state:
		"idle":
			if(abs(motion.x) > 10):
				motion *= .8
			else:
				 motion.x = 0
			stateIdle(activeR, activeL, activeD, isDash, isJump)
		"runL":
			motion.x = -speed # then the x coordinates of the vector be negative
			stateRunL(activeR, activeL, activeD, isDash, isJump)
		"runR":
			motion.x = speed # then the x coordinates of the vector be positive
			stateRunR(activeR, activeL, activeD, isDash, isJump)
		"slideL":
			motion.x = -speed / 2
			stateSlideL(activeR, activeL, activeD, isDash, isJump)
		"slideR":
			motion.x = speed / 2
			stateSlideR(activeR, activeL, activeD, isDash, isJump)
		"jumpL":
			jumpTime -= delta
			motion.x = -speed
			motion.y = -jumpforce
			stateJumpL(activeR, activeL, activeD, isDash, isJump)
		"jumpR":
			jumpTime -= delta
			motion.x = speed
			motion.y = -jumpforce
			stateJumpR(activeR, activeL, activeD, isDash, isJump)
		"fallL":
			motion.x = -speed
			stateFallL(activeR, activeL, activeD, isDash, isJump)
		"fallR":
			motion.x = speed
			stateFallR(activeR, activeL, activeD, isDash, isJump)
		"fallN":
			motion.x = lerp(motion.x, 0, 0.01)
			#no modification to vectors
			stateFallN(activeR, activeL, activeD, isDash, isJump)
		"jumpN":
			jumpTime -= delta
			motion.y = -jumpforce
			motion.x = lerp(motion.x, 0, 0.1)
			stateJumpN(activeR, activeL, activeD, isDash, isJump)
		"dashR":
			dashTime -= delta
			motion.y = 0
			motion.x = dashForce
			stateJumpR(activeR, activeL, activeD, isDash, isJump)
		"dashL":
			dashTime -= delta
			motion.y = 0
			motion.x = -dashForce
			stateDashL(activeR, activeL, activeD, isDash, isJump)
		"stopRunL":
			motion.x = lerp(motion.x, 0, 0.1)
			stateStopRunL(activeR, activeL, activeD, isDash, isJump)
		"stopRunR":
			motion.x = lerp(motion.x, 0, 0.1)
			stateStopRunR(activeR, activeL, activeD, isDash, isJump)
	motion.y += gravity + delta # Always make the player fall down
	set_velocity(motion)
	set_up_direction(Vector2.UP)
	move_and_slide()
	motion = velocity#move and slide is better for platformers. add hit boxes elsewhere.

	# Move and slide is a function which allows the kinematic body to detect
	# collisions and move accordingly
	
	######Block for handling interactions
	
	
	########
	


func stateIdle(activeR, activeL, activeD, isDash, isJump):
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
	
	
	pass
	
	
	
	
func stateRunR(activeR, activeL, activeD, isDash, isJump):
	if(state == "runR"):
		if !is_on_floor():
			state = "fallR"
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

func stateRunL(activeR, activeL, activeD, isDash, isJump):
	print("test")
	if(state == "runL"):
		if !is_on_floor():
			state = "fallL"
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

func stateDashR(activeR, activeL, activeD, isDash, isJump):
	if(state == "dashR"):
		#if you hit a wall, immediately stop.
		if(is_on_wall()):
			state = "fallR"
		else:
			if(!dashTime > 0):#if not still dashing go to run
				state = "runR"

func stateDashL(activeR, activeL, activeD, isDash, isJump):
	if(state == "dashL"):
		#if you hit a wall, immediately stop.
		if(is_on_wall()):
			state = "fallL"
		else:
			if(!dashTime > 0):#if not still dashing go to run
				state = "runL"



func stateSlideR(activeR, activeL, activeD, isDash, isJump):
	if(state == "slideR"):
		if(activeR):#runR -> runR
			state = "slideR"
		else:
			state = "runR"
	else:
		state == "slideR"


func stateSlideL(activeR, activeL, activeD, isDash, isJump):
	if(state == "slideL"):
		#todo add slide time.
		
		if(activeL):#runR -> runR
			state = "slideL"
		else:
			state = "runL"

func stateJumpN(activeR, activeL, activeD, isDash, isJump):
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

	
func stateJumpR(activeR, activeL, activeD, isDash, isJump):
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

func stateJumpL(activeR, activeL, activeD, isDash, isJump):
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


func stateFallN(activeR, activeL, activeD, isDash, isJump):
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

	
	
	
func stateFallR(activeR, activeL, activeD, isDash, isJump):
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


func stateFallL(activeR, activeL, activeD, isDash, isJump):
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
	

func stateStopRunR(activeR, activeL, activeD, isDash, isJump):
	if(state == "stopRunR"):
		if(activeR):#runR -> runR
			state = "runR"
			if(activeD):#runR -> slideR
				state = "slideR"
		else:
			state = "idle"
	
func stateStopRunL(activeR, activeL, activeD, isDash, isJump):
	if(state == "stopRunL"):
		if(activeL):#runR -> runR
			state = "runL"
		if(activeR):#runR -> slideR
				state = "slideL"
		else:
			state = "idle"





func adustFacing():
	#fix later
	if(motion.x == 0):
		pass
	elif(motion.x > 0):
		facing.rotation_degrees = 0
	else:
		facing.rotation_degrees = 180
	



func get_Input(delta):
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
	if(r == null || a == null):
		print("error, interact not defined")
		
		
func takeDamage():
	pass
