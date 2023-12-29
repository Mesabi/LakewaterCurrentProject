extends Node2D

@export var peaceful = false#adding this to help with optimization.
var PlayerPos = Vector2()
var myEnemies

# Called when the node enters the scene tree for the first time.
func _ready():
	myEnemies = get_children()
	getPlayerPos()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(!peaceful):
		getPlayerPos()
	pass



func getPlayerPos():
	PlayerPos = Global.getWorldManager().get_node("Player").global_position
	
func updateMyEnemies():
	#restablish link for spawned enemies, etc. 
	pass
