extends CharacterBody2D
#the goal here will be to write a few different state machines that are determined by
#enemy type.


@export var EnemyType = "undefined"

@onready var health = $Health_System
@onready var hitbox = $Hitbox
@onready var _anim = $AnimationPlayer
@onready var _sprite = $Sprite2D
@onready var isLeft = false


var motion = Vector2()
var gravity = 32



var state = "idle"# default / idle / aggressive / 
var behavior = "passive"# passive / chase / aggressive / flee / react

# Called when the node enters the scene tree for the first time.
func _ready():
	gravity = Global.gravity
	_anim.play("Idle")
	
	
	pass # Replace with function body.

func _physics_process(delta):
	testQuick()
	#motion = Vector2.ZERO
	move_and_slide()
	#moveEnemy(delta)
	pass
	
	
	
func testQuick():
	if Input.is_action_just_pressed("TEST"):
		print("test")
		#applyForce(Vector2.RIGHT)








func getPlayerPos():
	get_parent().getPlayerPos()


func brain(delta):
	pass


func stateMachine(delta):
	
	match(state):
		"idle":
			_anim.play("Idle")
		"damaged":
			_anim.play("TakeDamage")
		"move":#decide if this is being seperated into L and R
			pass
		"attack1":#
			pass
		"attack2":
			pass
		"rangedAttack1":
			pass
		"rangedAttack2":
			pass
		_:
			pass


func stateMachineManager(delta):
	# passive / chase / aggressive / flee / react
	match behavior:
		"passive":
			stateMachinePassive(delta)
		"chase":
			stateMachineBehaviorChange(delta)
		"aggressive":
			stateMachine(delta)
		"flee":
			pass
		"react":
			pass
		_:
			pass

func stateMachinePassive(delta):
	match(state):
		"idle":
			_anim.play("Idle")
		"patrol":
			pass
		"investigate":
			pass
		_:
			pass
	pass

func stateMachineBehaviorChange(delta):
	#contains all behavioral states so that the enemy can be flipped between them
	match(state):
		"idle":
			_anim.play("Idle")
		"patrol":
			pass
		"investigate":
			pass
		_:
			pass


func flip():
	if(false):
		_sprite.flip_h = true
		isLeft = true
	if(false):
		isLeft = false
		_sprite.flip_h = false

func moveEnemy(delta):
	#motion.y += gravity + delta # Always make the player fall down
	#set_velocity(motion)
	#set_up_direction(Vector2.UP)#look into what this does...
	move_and_slide()
	#motion = velocity#move and slide is better for platformers. add hit boxes elsewhere.

func takeDamage(amt):
	health.deductHealthAndKill(amt)
	pass
	
func applyForce(amt : Vector2):
	velocity.x = amt.x
	velocity.y = amt.y
	pass
	

func doAnim():
	#this will save time in the long run... I think
	_anim.play(state)
	


func enemyIsDead():
	get_parent().queue_free()
	pass
