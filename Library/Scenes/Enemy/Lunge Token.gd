extends Node2D

var cooldownOne: Timer#cooldown for attack runs
var cooldownOneActive : bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func countFrom(amt):
	cooldownOne.wait_time = amt
	cooldownOne.start()
	cooldownOneActive = true

func _on_Timer_One_timeout():
	print("Timer One done")
	queue_free()
