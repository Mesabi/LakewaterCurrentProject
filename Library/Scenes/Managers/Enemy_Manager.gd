extends Node2D

@export var peaceful : bool = false#adding this to help with optimization.
var PlayerPos = Vector2()
var myEnemies
var myCount = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	myEnemies = get_children()
	myCount = get_child_count()
	#getPlayerPos()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(!peaceful):
		pass
		#getPlayerPos()
	pass



func getPlayerPos():
	#cannot call this in a frame where the player is dead. 
	if(Global.playerPresent):
		PlayerPos = Global.getWorldManager().get_node("Player").global_position
	else:
		PlayerPos = Vector2.ZERO
func updateMyEnemies():
	myCount = get_child_count()
	#restablish link for spawned enemies, etc. 
	pass
