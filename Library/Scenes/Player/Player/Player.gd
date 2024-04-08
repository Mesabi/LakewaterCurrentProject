extends CharacterBody2D

#lerp broke 3->4 needs replacement
var debug : bool = false


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
var attackCooldown : float = 0.5
var attackLength = .5
var attackTime = 0.0
@onready var attackManager = $Attack
@onready var actionLabel = $ActionLabel

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
#@onready var facing = $sprite/facing #handled by isLeft

var interactResource = null
var interactAction = null
#onready var anim = $Autumn/AnimationPlayer
#onready var currenAnim = anim.get("parameters/playback")
var state = CharacterState.Idle#CharacterState.Idle
var behavior = CharacterBehavior.Passive #"passive" # passive / change / attack / other 

enum CharacterState {
	Idle,#
	Interact,
	RunLeft,#
	RunRight,#
	SlideLeft,#
	SlideRight,#
	JumpLeft,#
	JumpRight,#
	FallLeft,#
	FallRight,#
	FallNone,#
	JumpNone,#
	DashRight,
	DashLeft,
	StopRunLeft,
	StopRunRight,
	Prone,
	StillAttackLeft,
	StillAttackRight,
	MoveAttackLeft,
	MoveAttackRight,
	UpAttackLeft,
	UpAttackRight,
	DashAttackRight,
	DashAttackLeft,
	SpellLeft,
	SpellRight,
	Error,
	Cutscene
}
enum CharacterBehavior{
	Passive,
	Change,
	Attack,
	Other,
	Debug
}




# Called when the node enters the scene tree for the first time.
func _ready():
	#print(self.position)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	label1.text = str("x : ")+str(motion.x) + "y : " + str(motion.y)
	label2.text = str(attackLength)
	label3.text = str(state)
	if(debug):
		doDebugTask()
	#velocity = Vector2.ZERO
	cam.position = self.position
	getInput(delta)#
	handleInputLogic(delta)
	stateMachineManager(delta)




func getInput(delta):
	activeR = Input.is_action_pressed("ui_right")#finalized
	activeL = Input.is_action_pressed("ui_left")#finalized
	activeU = Input.is_action_pressed("ui_up")#finalized
	activeD = Input.is_action_pressed("ui_down")#finalized
	activeDash = Input.is_action_pressed("SHIFT")#finalized
	activeSpell = Input.is_action_pressed("A")#TODO settle on Name: "Charge" or "Spell
	activeBlock = Input.is_action_pressed("X")#finalized
	activeParry = Input.is_action_pressed("C")#TODO Pick better name
	activeSwap = Input.is_action_pressed("S")
	activeOther = Input.is_action_pressed("D")
	activeReset = Input.is_action_pressed("R")
	activeInteract = Input.is_action_pressed("E")
	activeAttack = Input.is_action_pressed("Z")#finalized


func handleInputLogic(delta):
	if(activeAttack && !isAttacking):
		isAttacking = true
		behavior = CharacterBehavior.Change
		attackLength = 0
		attackManager.attack(isLeft)
		if(debug):
			print("debugging!")
		#attackCooldown = 1# move this line ASAP
	if(!isAttacking && activeInteract):
		doInteract()
	#if(state == "interact" && Global.inInteraction == false):#NOTE might be redundant
		##releases player to idle when interaction is over
		#state = "idle"
		#behavior = "passive"
	isJump = activeU#will need update later
	
	if is_on_floor(): # If the ground checker is colliding with the ground
		currentJumps = 0#reset jumps
	if(!canDash):#reset dashes
		pass
	if(activeSwap):
		#doWeaponSwap()
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
func stateMachineMove(delta):
	####Movement State machine. works ok, needs more "crunch"
	#consider run speed slowly picking up?
	#idle / runL / runR / jumpL / jumpR / duck / etc.
	#change states is in different function
	#attack states is in different function
	match state:
		CharacterState.Idle:
			#drift to stop.
			if(abs(motion.x) > 10):#needs update
				motion *= .8
			else:
				motion.x = 0
			stateIdle()
			_animation_player.play("Idle")
		CharacterState.Interact:
			stateInteract(activeInteract)
		CharacterState.RunLeft:
			motion.x = -speed # then the x coordinates of the vector be negative
			stateRunL()
			_animation_player.play("walk")
		CharacterState.RunRight:
			motion.x = speed # then the x coordinates of the vector be positive
			stateRunR()

			_animation_player.play("walk")
		CharacterState.SlideLeft:
			_animation_player.play("slide")
			motion.x = -speed * 1.5
			stateSlideL()
		CharacterState.SlideRight:
			_animation_player.play("slide")
			motion.x = speed * 1.5
			stateSlideR()
		CharacterState.JumpLeft:
		#fix jump anim for multijump
		#also sync this up when you get a chance and redo these sprites
			_animation_player.play("jump")
			jumpTime -= delta
			motion.x = -speed
			motion.y = -jumpforce
			stateJumpL()
		CharacterState.JumpRight:
			_animation_player.play("jump")
			jumpTime -= delta
			motion.x = speed
			motion.y = -jumpforce
			stateJumpR()
		CharacterState.FallLeft:
			_animation_player.play("Fall")
			motion.x = -speed
			stateFallL()
		CharacterState.FallRight:
			_animation_player.play("Fall")
			motion.x = speed
			stateFallR()
		CharacterState.FallNone:
			_animation_player.play("Fall")
			motion.x = 0#lerp(motion.x, 0, 0.01)
			#no modification to vectors
			stateFallN()
		CharacterState.JumpNone:
			#consider modifying this to have more interactions with dash mechanics.
			#as is, this creates a a hard stop.
			_animation_player.play("jump")
			jumpTime -= delta
			motion.y = -jumpforce
			motion.x = 0#lerp(motion.x, 0, 0.001)
			stateJumpN()
		CharacterState.DashRight:
			dashTime -= delta
			motion.y = 0
			motion.x = dashForce
			stateDashR()
		CharacterState.DashLeft:
			dashTime -= delta
			motion.y = 0
			motion.x = -dashForce
			stateDashL()
		CharacterState.StopRunLeft:
			motion.x = 0#lerp(motion.x, 0, 0.1)
			stateStopRunL()
		CharacterState.StopRunRight:
			motion.x = 0#lerp(motion.x, 0, 0.1)
			stateStopRunR()
		_:
			pass
			
			


func stateIdle():
	#this shouldn't need to update the flip of the sprite.
	if(isJump):
			_animation_player.play("jump")
			state = CharacterState.JumpNone
	if(activeR && !activeL):#idle -> runR
		state = CharacterState.RunRight
		if(isDash):
			state = CharacterState.DashRight
	if(activeL && !activeR):#idle -> runL
		state = CharacterState.RunLeft
		if(isDash):
			state = CharacterState.DashLeft
	
			
func stateInteract(activeI):
	#if can interact do: state == interact.
	if(Global.inInteraction):
		state = CharacterState.Interact
	else:
		state = CharacterState.Idle
	
	
	
	
func stateRunR():
	if(state == CharacterState.RunRight):
		if !is_on_floor():
			state = CharacterState.FallRight
			return
		if(isJump):
			state = CharacterState.JumpRight
		elif(isDash):
			state = CharacterState.DashRight
		else:
			if(activeR):#runR -> runR
				if(activeD):#runR -> slideR
					state = CharacterState.SlideRight
				else:
					state = CharacterState.RunRight
			else:
				state = CharacterState.StopRunRight
				if(isJump):
					state = CharacterState.JumpRight

func stateRunL():

	if(state == CharacterState.RunLeft):
		if !is_on_floor():
			state = CharacterState.FallLeft
			return
		if(isJump):
			state = CharacterState.JumpLeft
		elif(isDash):
			state = CharacterState.DashLeft
		else:
			if(activeL):#runR -> runR
				if(activeD):#runR -> slideR
					state = CharacterState.SlideLeft
				else:
					state = CharacterState.RunLeft
			else:
				state = CharacterState.StopRunLeft
				if(isJump):
					state = CharacterState.JumpLeft

func stateDashR():
	if(state == CharacterState.DashRight):
		#if you hit a wall, immediately stop.
		if(is_on_wall()):
			state = CharacterState.FallRight
		else:
			if(dashTime < 0):#if not still dashing go to run
				state = CharacterState.RunRight
		if(isJump):
			state = CharacterState.JumpRight
			if(activeL):
				state = CharacterState.JumpLeft
			

func stateDashL():
	if(state == CharacterState.DashLeft):
		#if you hit a wall, immediately stop.
		if(is_on_wall()):
			state = CharacterState.FallLeft
		else:
			if(dashTime < 0):#if not still dashing go to run
				state = CharacterState.RunLeft
		if(isJump):
			state = CharacterState.JumpRight
			if(activeL):
				state = CharacterState.JumpLeft


func stateAttackStillR():
	_animation_player.play("attackBasic")
	#code for attacks



func stateAttackStillL():
	_animation_player.play("attackBasic")

	

func stateAttackMoveR():
	_animation_player.play("attackForward")

func stateAttackMoveL():
	_animation_player.play("attackForward")

func stateSlideR():
	if(state == CharacterState.SlideRight):
		if(activeR):#runR -> runR
			state = CharacterState.SlideRight
		else:
			state = CharacterState.RunRight
	else:
		state == CharacterState.SlideRight


func stateSlideL():
	if(state == CharacterState.SlideLeft):
		#todo add slide time.
		
		if(activeL):#runR -> runR
			state = CharacterState.SlideLeft
		else:
			state = CharacterState.RunLeft

func stateJumpN():
	if(state == CharacterState.JumpNone):
		if(jumpTime > 0):#
			if(activeL):#runR -> runR
				state = CharacterState.JumpLeft
			elif(activeR):
				state = CharacterState.JumpRight
			else:
				state = CharacterState.JumpNone
		else:
			if(activeL):#runR -> runR
				state = CharacterState.FallLeft
			elif(activeR):
				state = CharacterState.FallRight
			else:
				state = CharacterState.FallNone

	
func stateJumpR():
	if(state == CharacterState.JumpRight):
		if(jumpTime > 0):
			if(activeL):#runR -> runR
				state = CharacterState.JumpLeft
			elif(activeR):
				state = CharacterState.JumpRight
			else:
				state = CharacterState.JumpNone
		else:
			if(activeL):#runR -> runR
				state = CharacterState.FallNone
			else:
				state = CharacterState.FallRight

func stateJumpL():
	if(state == CharacterState.JumpLeft):
		if(jumpTime > 0):
			if(activeR):#runR -> runR
				state = CharacterState.JumpRight
			elif(activeL):
				state = CharacterState.JumpLeft
			else:
				state = CharacterState.FallNone
		else:
			if(activeR):#runR -> runR
				state = CharacterState.FallRight
			else:
				state = CharacterState.FallLeft


func stateFallN():
	if(state == CharacterState.FallNone):
		if is_on_floor():
			if(activeL):#runR -> runR
				state = CharacterState.RunLeft
			elif(activeR):
					state = CharacterState.RunRight
			else:
				state = CharacterState.Idle
		else:
			if(isJump):
				if(activeR):#runR -> runR
					state = CharacterState.JumpRight
				elif(activeL):
					state = CharacterState.JumpLeft
				else:
					state = CharacterState.JumpNone
			else:
				if(activeR):#runR -> runR
					state = CharacterState.FallRight
				elif(activeL):
					state = CharacterState.FallLeft
				else:
					state = CharacterState.FallNone

	
	
	
func stateFallR():
	if(state == CharacterState.FallRight):
		if is_on_floor():
			if(activeR):#runR -> runR
				state = CharacterState.RunRight
			else:
				if(activeL):
					state = CharacterState.RunLeft
				else:
					state = CharacterState.Idle
		else:
			if(isJump):
				if(activeL):#runR -> runR
					state = CharacterState.JumpLeft
				else:
					state = CharacterState.JumpRight
			else:
				if(activeL):#runR -> runR
					state = CharacterState.FallLeft
				else:
					state = CharacterState.FallRight


func stateFallL():
	if(state == CharacterState.FallLeft):
		if is_on_floor():
			if(activeL):#runR -> runR
				state = CharacterState.RunLeft
			elif(activeR):
					state = CharacterState.RunRight
			else:
				state = CharacterState.Idle
		else:
			if(isJump):
				if(activeR):#runR -> runR
					state = CharacterState.JumpRight
				else:
					state = CharacterState.JumpLeft
			else:
				if(activeR):#runR -> runR
					state = CharacterState.FallRight
				else:
					state = CharacterState.FallLeft
	

func stateStopRunR():
	if(state == CharacterState.StopRunRight):
		if(activeR):#runR -> runR
			state = CharacterState.RunRight
			if(activeD):#runR -> slideR
				state = CharacterState.SlideRight
		else:
			state = CharacterState.Idle
	
func stateStopRunL():
	if(state == CharacterState.StopRunLeft):
		if(activeL):
			state = CharacterState.RunLeft
		if(activeR):
				state =  CharacterState.SlideLeft
		else:
			state = CharacterState.Idle




func stateMachineSetAttack(delta):
	#chooses which attack state to use by referencing current state.
	#attackStill(L/R) / attackMove(L/R) / attackUp(L/R) /attackDash(L/R) attackDown(L/R)	

		behavior = CharacterBehavior.Attack
		match(state):
			CharacterState.Idle:
				#state = "attackStllN"#fix direction later
				if(isLeft):
					state = CharacterState.StillAttackLeft
				else:
					state = CharacterState.StillAttackRight

			CharacterState.Interact:
				return
			CharacterState.RunLeft:
				state = CharacterState.MoveAttackLeft
			CharacterState.RunRight:
				state = CharacterState.MoveAttackRight
			CharacterState.SlideLeft:#sliding will move player faster, but can't attack.
				return
			CharacterState.SlideRight:
				return
			CharacterState.JumpLeft:
				state = CharacterState.UpAttackLeft
			CharacterState.JumpRight:
				state = CharacterState.UpAttackRight
			CharacterState.FallLeft:
				state = CharacterState.FallLeft
			CharacterState.FallRight:
				state = CharacterState.FallRight
			CharacterState.FallNone:####
				return##
			CharacterState.JumpNone:####Neutrals need fixing.
				return#
			CharacterState.DashRight:####
				state = CharacterState.DashAttackRight
			CharacterState.DashLeft:
				state = CharacterState.DashAttackLeft
			CharacterState.StopRunLeft:
				state = CharacterState.StillAttackLeft
			CharacterState.StopRunRight:
				state = CharacterState.StillAttackRight
		
func returnFromAttack():
	pass

func stateMachineManager(delta):
	flip()
	###Manages the state of the player.
	#state == state (anims and whatnot)
	#behavior == what player is doing. <-tie to certain anims? (i.e. aggressive idle vs. passive)
	
	

	match(behavior):
		CharacterBehavior.Passive:
			stateMachineMove(delta)
		CharacterBehavior.Change:#used to swap from move -> attack
			stateMachineSetAttack(delta)
		CharacterBehavior.Attack:
			stateMachineDoAttack(delta)
			incrementAttackCoolDown(delta)
		CharacterBehavior.Other:#use for interact, cutscenes, etc. 
			pass
			
	###probably should move this block
	motion.y += gravity + delta # Always make the player fall down
	set_velocity(motion)
	set_up_direction(Vector2.UP)#look into what this does...
	move_and_slide()
	motion = velocity#move and slide is better for platformers. add hit boxes elsewhere.
	

func stateMachineDoAttack(delta):

	if(!isAttacking):#if no longer attacking, set to idle and move on.
		state = CharacterState.Idle#make more elegent
		behavior = CharacterBehavior.Passive
		return
	else:
		isAttackEnd()
		match state:
			CharacterState.StillAttackLeft:
				motion.x = 0 
				stateAttackStillL()
			CharacterState.StillAttackRight:
				motion.x = 0 
				stateAttackStillR()
			CharacterState.MoveAttackRight:
				motion.x = speed 
				stateAttackMoveR()
			CharacterState.MoveAttackLeft:
				motion.x = -speed # then the x coordinates of the vector be negative
				stateAttackMoveL()

	
		
func test():
	print(state)
	attackLength = 0
	#state = "undefined"
	#_animation_player.play("attackBasic")


func setInteract(r, a):
	#Resource = r
	#Action = a
	if(a != null):
		actionLabel.text = "can interact"
	else:
		actionLabel.text = ""
	interactResource = r
	interactAction = a

		
func doInteract():
	Global.doConversation(interactResource,interactAction)
	state = CharacterState.Interact

		
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

func isAttackEnd():
	if(attackLength < attackCooldown):
		isAttacking = true
	else:
		isAttacking = false

func incrementAttackCoolDown(delta):
	if(attackLength < attackCooldown):
		attackLength += delta

func resetAttackLength():
	attackLength = 0
	print("reset attack length")
	
func doDebugTask():
	print("task")
