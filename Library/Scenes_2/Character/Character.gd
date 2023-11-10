extends KinematicBody2D


# Declare member variables here. Examples:
var speed = 20000
var velocity : Vector2
onready var cam = $CanvasLayer/Camera2D


var interactResource = ""
var interactAction = ""
#onready var anim = $Autumn/AnimationPlayer
#onready var currenAnim = anim.get("parameters/playback")


# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.
#
#func _process(delta):
#	print("running")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#velocity = Vector2.ZERO
	cam.position = self.position
	# Input handling
	if Input.is_action_pressed("ui_right"):
		velocity.x += speed
	if Input.is_action_pressed("ui_left"):
		velocity.x -= speed
		
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1000
	
	if Input.is_action_pressed("ui_up"):
		pass

	# Normalizing diagonal movement
	velocity = velocity.normalized()
	# Applying movement
	velocity *= speed * delta
	velocity.y += delta * 3200
	move_and_slide(velocity)

	get_Input(delta)
#	if(velocity != Vector2.ZERO):
#		anim.play("walking")
#	else:
#		anim.play("Autumn")






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
		print(Global.inInteraction)
		
	
	if(Input.is_action_just_pressed("click")):
		#print("mouse")
		#print(get_global_mouse_position())
		#print("player")
		#print(player.global_position)
		#print(get_global_mouse_position().distance_to(player.global_position))
		pass
	
	if(Input.is_action_just_pressed("interact")):#change to "switch weapon" also add hot keys.
		#player.weapon.switch()
		if(interactResource != ""):
			print(interactResource)
			Global.doConversation(interactResource, interactAction)
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
