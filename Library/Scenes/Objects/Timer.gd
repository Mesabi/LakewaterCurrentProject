extends Node2D


@export var time = 0
var timer: Timer
var done = false
var start = false


func _process(delta):
	if(start):
		measureTime()


func startTimer(amt):
	time = amt
	start = true

func measureTime():
	timer = Timer.new()
	timer.wait_time = time
	add_child(timer)
	timer.connect("timeout", Callable(self, "_on_Timer_timeout"))
	timer.start()
	print("timer start")


func _on_Timer_timeout():
	# Your code here
	done = true
	print("timer done")
