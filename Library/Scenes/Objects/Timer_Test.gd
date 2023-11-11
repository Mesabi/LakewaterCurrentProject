extends Node2D

var timer: Timer

func _ready():
	timer = Timer.new()
	timer.wait_time = 2.0
	add_child(timer)
	timer.connect("timeout", self, "_on_Timer_timeout")
	timer.start()

func _on_Timer_timeout():
	# Your code here
	print("Timer completed after 2 seconds!")
