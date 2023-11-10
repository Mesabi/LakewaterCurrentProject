extends Node2D

var save
onready var resources = $Resources
var state
onready var player = $Player
onready var HUD = $CanvasLayer/HUD

#onready var health = $Player_Health
#onready var UI = $CanvasLayer/test_ui
#Player/Camera2D/test_ui

onready var level = $Level

var weapons_free = false


#currently, weapon ammo exists out of a "pool" here.
#when any reload, weapon change, etc. happens, we update the main resources with this amt
#and switch it to the main amount.
var current_weapon = "gatling"
var currentAmmo = 00
var currentReloads  = 00


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.loadLevel(self, "res://Library/Levels/Test_Managers_Level.tscn")#res://Library/Levels/test-movement.tscn
	Global.setGlobalObjective()
	#get_parent().get_child(0).readFile()
	pass # Replace with function body.



func _process(delta):
	pass
	#getInput()


func getInput():
	#will be for non player movement, menus, pause, volume, etc.
	pass

func getHUD():
	return HUD

