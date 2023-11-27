extends Node2D
# currently running this with 5 potential timers, might add more.

@onready var cooldownOne = $TimerOne
var cooldownOneActive : bool = false

@onready var cooldownTwo = $TimerTwo
var cooldownTwoActive : bool = false

@onready var cooldownThree = $TimerThree
var cooldownThreeActive : bool = false

@onready var cooldownFour = $TimerFour
var cooldownFourActive : bool = false

@onready var cooldownFive = $TimerFive
var cooldownFiveActive : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func doTimerStartTasks():
	pass
	


func set_timer_One(amt):
	cooldownOne.wait_time = amt
	cooldownOne.start()
	cooldownOneActive = true

func set_timer_Two(amt):
	cooldownTwo.wait_time = amt
	cooldownTwo.start()
	cooldownTwoActive = true

func set_timer_Three(amt):
	cooldownThree.wait_time = amt
	cooldownThree.start()
	cooldownThreeActive = true

func set_timer_Four(amt):
	cooldownFour.wait_time = amt
	cooldownFour.start()
	cooldownFourActive = true

func set_timer_Five(amt):
	cooldownFive.wait_time = amt
	cooldownFive.start()
	cooldownFiveActive = true

func reset_timer_One():
	cooldownOne.stop()
	cooldownOne.wait_time = 0.0
	cooldownOneActive = false

func reset_timer_Two():
	cooldownTwo.stop()
	cooldownTwo.wait_time = 0.0
	cooldownTwoActive = false

func reset_timer_Three():
	cooldownThree.stop()
	cooldownThree.wait_time = 0.0
	cooldownThreeActive = false

func reset_timer_Four():
	cooldownFour.stop()
	cooldownFour.wait_time = 0.0
	cooldownFourActive = false

func reset_timer_Five():
	cooldownFive.stop()
	cooldownFive.wait_time = 0.0
	cooldownFiveActive = false


func _on_TimerOne_timeout():
	reset_timer_One()
	pass # Replace with function body.


func _on_TimerTwo_timeout():
	reset_timer_Two()
	pass # Replace with function body.


func _on_TimerThree_timeout():
	reset_timer_Three()
	pass # Replace with function body.


func _on_TimerFour_timeout():
	reset_timer_Four()
	pass # Replace with function body.


func _on_TimerFive_timeout():
	reset_timer_Five()
	pass # Replace with function body.
