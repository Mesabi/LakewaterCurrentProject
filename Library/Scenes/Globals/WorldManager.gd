extends Node2D

var save
#@onready var resources = $Resources
var state
@onready var player = $Player
@onready var playerSetup = preload("res://Library/Scenes/Player/Player/Player.tscn")
var isPlayer = true #set via globals as well. 


var playerWeapon = "empty"


@onready var HUD = $CanvasLayer/HUD

#onready var health = $Player_Health
#onready var UI = $CanvasLayer/test_ui
#Player/Camera2D/test_ui

@onready var level = $Level
@onready var levelManager


# Called when the node enters the scene tree for the first time.
func _ready():
	checkGlobals()
	removePlayerIfInvalid()

	pass # Replace with function body.



func _process(delta):
	if Input.is_action_just_pressed("TEST"):
		Global.enterDebugMode()
		#print(levelManager.determineCheckpointValid("01"))
		#addPlayer()
		#test()
	#getInput(delta)

func checkGlobals():
	isPlayer = Global.playerPresent


func removePlayerIfInvalid():
	if(!isPlayer):
		player.queue_free()

func addPlayer():
	#adds player to scene at the current checkpoint.
	var spawnPos = Vector2.ZERO#default 0,0
	if(levelManager.determineCheckpointValid(States.currentCheckpoint)):
		spawnPos = levelManager.getThisCheckpoint(States.currentCheckpoint)
	player.queue_free()
	var respawn = playerSetup.instantiate()
	add_child(respawn)
	player = respawn
	respawn.position = spawnPos
	
	pass






func getInput(delta):
	# Some of these may need to be reset for actions that should be 'just' pressed. 
	### Long Term This should only be input. 
	player.activeR = Input.is_action_pressed("ui_right")
	player.activeL = Input.is_action_pressed("ui_left")
	player.activeU = Input.is_action_pressed("ui_up")
	player.activeD = Input.is_action_pressed("ui_down")
	player.activeDash = Input.is_action_pressed("SHIFT")
	player.activeSpell = Input.is_action_pressed("A")
	player.activeBlock = Input.is_action_pressed("X")
	player.activeParry = Input.is_action_pressed("C")
	player.activeSwap = Input.is_action_pressed("S")
	player.activeOther = Input.is_action_pressed("D")
	player.activeReset = Input.is_action_pressed("R")
	player.activeInteract = Input.is_action_pressed("E")
	player.activeAttack = Input.is_action_pressed("Z")


func getHUD():
	return HUD


func test():
	print("this was a test")
	#Global.doConversation("res://Library/Dialog/Drafts/test-gd4.dialogue", "this_is_a_node_title")
	#player.test()
func testThis(that):
	print("----")
	print(that)
	print("was just tested")
