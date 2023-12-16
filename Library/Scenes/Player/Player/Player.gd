extends CharacterBody2D

#lerp broke 3->4 needs replacement



###INPUTS###
var oldMotion = Vector2()
var isLeft = false
var activeR = false
var activeL = false
var activeU = false
var activeD = false
var activeInteract = false
var activeAttack = false
var activeDash = false
var activeSpell = false
var activeBlock = false
var activeParry = false
var activeSwap = false
var activeOther = false
var activeReset = false

	
	#
var isJump = false
var isDash = false
var isAttacking = false
var doneAttacking = true
var attackCooldown : float = 0

var speed = 750
#var velocity : Vector2
var gravity = 32
var jump = 20
var motion = Vector2.ZERO#probably should rename this to velocity for consistency. 
@export var jumpforce = 400 # The jump force of the character
@export var jumpLength = .5
var jumpTime = 0
@onready var _animation_player = $AnimationPlayer
@onready var _sprite = $Sprite2D

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


@onready var stillAttack = preload("res://Library/Scenes/Player/Weapon/Sword/StillAttack.tscn")
var thisAttack = null

@onready var attackPosL = $Attack/AttackPosLeft
@onready var attackPosR = $Attack/AttackPosRight


@onready var cam = $CanvasLayer/Camera2D
@onready var label1 = $CanvasLayer/Camera2D/Label1
@onready var label2 = $CanvasLayer/Camera2D/Label2
@onready var label3 = $CanvasLayer/Camera2D/Label3
@onready var facing = $sprite/facing

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
	label1.text = str(activeAttack)#"x : "+str(motion.x) + "y : " + str(motion.y)
	label2.text = str(attackCooldown)
	label3.text = str(state)

	#velocity = Vector2.ZERO
	cam.position = self.position
	getInput(delta)
	if(isAttacking):
		handleAttack(delta)
	else:
		move(delta)
	pass


func getInput(delta):
	#some of these may need to be reset for actions that should be 'just' pressed. 
	
	activeR = Input.is_action_pressed("ui_right")
	activeL = Input.is_action_pressed("ui_left")
	activeU = Input.is_action_pressed("ui_up")
	activeD = Input.is_action_pressed("ui_down")
	activeDash = Input.is_action_pressed("SHIFT")
	activeSpell = Input.is_action_pressed("A")
	activeBlock = Input.is_action_pressed("X")
	activeParry = Input.is_action_pressed("C")
	activeSwap = Input.is_action_pressed("S")
	activeOther = Input.is_action_pressed("D")
	activeReset = Input.is_action_pressed("R")
	
	activeInteract = Input.is_action_pressed("E")
	if(Input.is_action_pressed("Z")):
		if(!activeAttack):
			activeAttack = true
			attackCooldown = 1# move this line ASAP

	
	isJump = activeU#will need update later
	
	if is_on_floor(): # If the ground checker is colliding with the ground
		currentJumps = 0#reset jumps
		if(!canDash):#reset dashes
			pass
			
	



func flip():
	if(activeL && activeR):
		return
	else:
		if(activeL):
			_sprite.flip_h = true
			isLeft = true
		if(activeR):
			isLeft = false
			_sprite.flip_h = false

	#resetDash(delta)
func move(delta):
	flip()
	####Movement State machine. works ok, needs more "crunch"
	#consider run speed slowly picking up?
	#idle / runL / runR / jumpL / jumpR / duck / attackstates
	match state:
		"idle":
			#drift to stop.
			if(abs(motion.x) > 10):#needs update
				motion *= .8
			else:
				motion.x = 0
			stateIdle()
			_animation_player.play("Idle")
		"interact":
			stateInteract(activeInteract)
		"runL":
			motion.x = -speed # then the x coordinates of the vector be negative
			stateRunL()

			_animation_player.play("walk")
		"runR":
			motion.x = speed # then the x coordinates of the vector be positive
			stateRunR()

			_animation_player.play("walk")
		"slideL":
			_animation_player.play("slide")
			motion.x = -speed * 1.5
			stateSlideL()
		"slideR":
			_animation_player.play("slide")
			motion.x = speed * 1.5
			stateSlideR()
		"jumpL":
		#fix jump anim for multijump
		#also sync this up when you get a chance and redo these sprites
			_animation_player.play("jump")
			jumpTime -= delta
			motion.x = -speed
			motion.y = -jumpforce
			stateJumpL()
		"jumpR":
			_animation_player.play("jump")
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
			motion.x = 0#lerp(motion.x, 0, 0.01)
			#no modification to vectors
			stateFallN()
		"jumpN":
			#consider modifying this to have more interactions with dash mechanics.
			#as is, this creates a a hard stop.
			_animation_player.play("jump")
			jumpTime -= delta
			motion.y = -jumpforce
			motion.x = 0#lerp(motion.x, 0, 0.001)
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
			motion.x = 0#lerp(motion.x, 0, 0.1)
			stateStopRunL()
		"stopRunR":
			motion.x = 0#lerp(motion.x, 0, 0.1)
			stateStopRunR()
		_:
			pass
			
			
			
			
	motion.y += gravity + delta # Always make the player fall down
	set_velocity(motion)
	set_up_direction(Vector2.UP)#look into what this does...
	move_and_slide()
	motion = velocity#move and slide is better for platformers. add hit boxes elsewhere.
	handleAttack(delta)
	# Move and slide is a function which allows the kinematic body to detect
	# collisions and move accordingly

func stateIdle():
	#technically this shouldn't need to update the flip of the sprite.

	if(isJump):
			_animation_player.play("jump")
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



func stateAttackStillR():
	if(doneAttacking):
		state = "idle"
	else:
		attackCooldown = 10
	pass



func stateAttackStillL():
	if(doneAttacking):
		state = "idle"
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

func handleAttack(delta):
	#attackStill(L/R) / attackMove(L/R) / attackUp(L/R) /attackDash(L/R) attackDown(L/R)	
	if(attackCooldown >= 0):
		if(activeAttack):
			attackCooldown -= delta
		if(attackCooldown < 0):
			activeAttack = false
	
	if(!activeAttack):
		
		
		return
		
		
	else:
		match(state):
			"idle":
				#state = "attackStllN"#fix direction later
				if(isLeft):
					state = "attackStillL"
					stateAttackStillL()
					
				else:
					state = "attackStillR"
					stateAttackStillR()
				_animation_player.play("attackBasic")
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
	state = "undefined"
	_animation_player.play("attackBasic")
		
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
