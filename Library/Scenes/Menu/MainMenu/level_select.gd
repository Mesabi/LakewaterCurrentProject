extends Control

#to be used to select levels in debug.
#on pause until I decide how levels are stored. 

@onready var levelList = $Panel/ItemList
var selection = null


var list = ["apples","bananas","coconut"]
# Called when the node enters the scene tree for the first time.
func _ready():
	updateLevelList()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func updateLevelList():
	for item in Paths.levels:
		levelList.add_item(item)
	pass


func _on_select_pressed():
	Global.loadLevel(Global.getWorldManager(), "res://Library/Levels/" + selection + ".tscn")
	
	get_parent().queue_free()#this might break depending on how this is called. 
	#right now, that culls the menu that called this function, and itself.


func _on_item_list_item_selected(index):
	selection = levelList.get_item_text(index)
	print(selection)
	pass # Replace with function body.
