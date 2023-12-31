extends Node2D
#used to run global operations. i.e. calling dialog, game objectives, score, timers, etc.



var current_scene = null#figure out what this does.


var IsolationTest = false #use this to run single scene instances. 

var inInteraction : bool = false#keeps the player from triggering multiple interactions at once. 
#note! I modified dialogue manager to change this when player is in dialog. NOTE GD4 Update broke this.
#I think DM might have added this natively in the 4.0 version? 


#for global variables that affect story or levels, use States.gd
var gravity = 32
var currentObjective = "Undefined"











# Global function for loading levels

func getWorldManager():
	return get_tree().get_root().get_node("Main").get_node("WorldManager")

func setGlobalObjective():
	getWorldManager().getHUD().updateObjective(currentObjective)
	pass

func doContextAction(action):
	print(action)
	match action:
		"Interact":
			print("")
		


func loadLevel(worldManager: Node2D, scenePath: String) -> void:
	#90% sure this is the only one of these that works	
	var currentLevel = null
	
	# Unload the current level if it exists
	if worldManager.has_node("Level"):
		currentLevel = worldManager.get_node("Level")
		currentLevel.queue_free()
		worldManager.remove_child(currentLevel)
	# Load the new level scene
	if(scenePath == null):
		#this needs the ability added to scan for existing levels, and make sure the path is valid.
		scenePath = "res://Library/Levels/Error.tscn"
	var scene = load(scenePath)
	#print(scenePath)
	# Instantiate the new level scene as a child of the World Manager
	currentLevel = scene.instantiate()
	currentLevel.name = "Level"
	worldManager.add_child(currentLevel)
	print(currentLevel.name)












func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)
	#setGlobalObjective()
#	print(current_scene)

func some_function():
	print("some function was callled")

func goto_scene(path):
	# This function will usually be called from a signal callback,
	# or some other function in the current scene.
	# Deleting the current scene at this point is
	# a bad idea, because it may still be executing code.
	# This will result in a crash or unexpected behavior.

	# The solution is to defer the load to a later time, when
	# we can be sure that no code from the current scene is running:

	call_deferred("_deferred_goto_scene", path)


func _deferred_goto_scene(path):
	
	# It is now safe to remove the current scene
	current_scene.free()

	# Load the new scene.
	var s = ResourceLoader.load(path)
	print(s)
	# Instance the new scene.
	current_scene = s.instantiate()

	# Add it to the active scene, as child of root.
	get_tree().get_root().add_child(current_scene)

	# Optionally, to make it compatible with the SceneTree.change_scene() API.
	get_tree().set_current_scene(current_scene)
	var main = load("res://Main.tscn")
	var Main = main.instantiate()
	current_scene.add_child(Main)


func doConversation(interact, line):
	#interact must be a valid path
	if(!inInteraction):
		if(!interact == null):
			var dlog = load(interact)
			DialogueManager.show_dialogue_balloon(dlog, line)
			inInteraction = true
	


