extends Node2D



var test = "test"

var current_scene = null

var has_met_nathan: bool = false

var num = 0
















# Global function for loading levels

func getWorldManager():
	return get_tree().get_root().get_node("Main").get_node("WorldManager")


func loadLevel(worldManager: Node2D, scenePath: String) -> void:
	var currentLevel = null

	# Unload the current level if it exists
	if worldManager.has_node("Level"):
		currentLevel = worldManager.get_node("Level")
		currentLevel.queue_free()
		worldManager.remove_child(currentLevel)
	# Load the new level scene
	var scene = load(scenePath)

	# Instantiate the new level scene as a child of the World Manager
	currentLevel = scene.instance()
	currentLevel.name = "Level"
	worldManager.add_child(currentLevel)












func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)
#	print(current_scene)



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
	current_scene = s.instance()

	# Add it to the active scene, as child of root.
	get_tree().get_root().add_child(current_scene)

	# Optionally, to make it compatible with the SceneTree.change_scene() API.
	get_tree().set_current_scene(current_scene)
	var main = load("res://Main.tscn")
	var Main = main.instance()
	current_scene.add_child(Main)
