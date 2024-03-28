extends Node2D
#used to run global operations. i.e. calling dialog, game objectives, score, timers, etc.
var a = 0

@onready var WM = preload("res://Library/Scenes/Globals/WorldManager.tscn")

var globalDebug : bool = false

var current_scene = null#figure out what this does.


var IsolationTest = false #use this to run single scene instances. 

var inInteraction : bool = false#keeps the player from triggering multiple interactions at once. 
#note! I modified dialogue manager to change this when player is in dialog. NOTE GD4 Update broke this.
#I think DM might have added this natively in the 4.0 version? 

###Constants Block###
#for global variables that affect story or levels, use States.gd
var gravity = 32
var currentObjective = "Undefined"
var playerPresent = true#flips things in WM
var debug = true


#these should be moved to states
enum playerWeapons {
	unarmed,
	unarmed2,
	knife,
	bow,
	test
}
enum playerPassives {
	noPassive,
	noPassive2,
	test
	
}
#this is fine.
enum levelType {
	level,
	peaceLevel,
	bossLevel,
	cutscene,
	debug,
	test,
	error
}


func newGameSetUp():
	pass





func startUp():
	#load_game()
	
	loadLevel(getWorldManager(), "res://Library/Levels/" + States.currentLevel + ".tscn")
	#res://Library/Levels/test-movement.tscn
	




func enterDebugMode():
	globalDebug = true
	iterate_children(get_tree().get_root(), "debug")

func exitDebugMode():
	globalDebug = false
	iterate_children(get_tree().get_root(), "debug")



func iterate_children(node, task):
	#used for full blown global operations on every node and it's children.
	#does this recursively. 
	#currently only used for debug purposes.
	#to do ALL nodes that exist, feed it <get_tree().get_root()>
	# Iterate through each child of the current node
	for i in range(node.get_child_count()):
		# Get the current child
		var child = node.get_child(i)
		match task:
			"print":
			# Print the name of the current child
				print("Child Name:", child.get_name())
			"debug":
				flipDebugFlags(child, globalDebug)
			_:
				pass
		# If the current child has children, recursively call the function
		if child.get_child_count() > 0:
			iterate_children(child, task)



func flipDebugFlags(node : Node, debug : bool):
	#sets debug nodes to selection. 
	if(node.is_in_group("debug")):
		node.debug == debug
		print(node.name + " entered debug mode!")


func doInstantiateGlobalTask(node : Node):
	#used to set certain tags on objects as they spawn in.
	#currently only using this for objects that spawn in after globalDebug is enabled. 
	if(!globalDebug):
		return
	else:
		flipDebugFlags(node, globalDebug)
	
	pass

func isWorldManager() -> bool:
	#function to confirm if WM exists.
	if(get_tree().get_root().get_node("Main").find_child("WorldManager") == null):
		return false
	else:
		return true


func instantiateWorldManager():
	#unless WM has been removed elsewhere, this should be called via getWorldManager() (untested!)
	var wm = WM.instantiate()
	get_tree().get_root().get_node("Main").add_child(wm)

func getWorldManager():
	#returns WM. Creates it if for some reason it doesn't exit.
	if(isWorldManager()):
		get_tree().get_root().get_node("Main").get_node("WorldManager")
	else:
		instantiateWorldManager()
		return get_tree().get_root().get_node("Main").get_node("WorldManager")

func setGlobalObjective():
	getWorldManager().getHUD().updateObjective(currentObjective)
	pass

func doContextAction(action):
	#honest to God no idea what this was for.
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
	print(scenePath)
	# Instantiate the new level scene as a child of the World Manager
	currentLevel = scene.instantiate()
	currentLevel.name = "Level"
	worldManager.add_child(currentLevel)
	worldManager.level = currentLevel#this might be unneccessary
	#NSdec: it might be worth removing the if statments,
	#as WM has level as a defined variable. 
	#print(currentLevel.name)
	worldManager.levelManager = currentLevel.get_node("Level_Manager")











func _ready():
	#var root = get_tree().get_root()
	#current_scene = root.get_child(root.get_child_count() - 1)
	#setGlobalObjective()
#	print(current_scene)
	pass

func some_function():
	#holdover from Nathan's dialog manager.
	print("some function was called")

func goto_scene(path):
	#NOTE Not my code -NS
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
	#there's probably a better way to do this...
	if(!inInteraction):
		if(!interact == null):
			var dlog = load(interact)
			DialogueManager.show_dialogue_balloon(dlog, line)
			inInteraction = true
	
func getdebug():
	return debug



func save_game():
	#NOTE:
	#currently unsure if this needs to be changed to .json
	#technically speaking it's better to use .json
	#additionally, all fields would be easier to deal with....
	#but honestly .txt seems to work fine for this for now. 
	#re-evaluate when major use of States.GD begins. -march 2024
	var save_game = FileAccess.open("user://saves/savegame.txt", FileAccess.WRITE)
	#print(save_game.get_path_absolute())
	for item in States.getBlock1():
		
		##var json_string = JSON.stringify(item)
		##print(json_string) 
		#this does not need to be stringified, and I prefer .txt atm. 
		save_game.store_line(item)
	save_game.close
	#print(save_game.get_path_absolute())

func load_game():
	#loads the save game file, and writes to States for gameplay.
	var load_game = FileAccess.open("user://saves/savegame.txt", FileAccess.READ)
	var lines = []
	# Open the file
	# Read line by line
	while !load_game.eof_reached():
		var line = load_game.get_line()
		lines.append(line)
	# Close the file
	load_game.close()
	#TODO write the aspect where this writes to States. 



func load_default():
	#loads the DEFAULT save game file from internal files, and writes to States. 
	#Then, creates a user save. 
	var load_default = FileAccess.open("user://saves/savegame.txt", FileAccess.READ)#fix this path. 
	#TODO same execution as load_game()
	
	#WARNING: if save_game() is called here, it will nuke player saves. decide before renabling. 
	#save_game()#saves this to memory.



func callTestA():
	#increments a counter and prints for testing purposes. 
	print(str(a))
	a += 1
