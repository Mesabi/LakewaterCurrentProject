extends Node2D


@export var points : int = 100
@export var isDead = false

@export var hasMax = false
@export var pointMax = 100



func deductHealth(amt):
	points -= amt
	if(points < 0):
		isDead = true
	return isDead


func deductHealthAndKill(amt):
	points -= amt
	if(points < 0):
		isDead = true
		var end = get_parent()
		end.queue_free()
		
func addHealth(amt):
	points += amt
	
func resurrect(amt):
	points = amt
	isDead = false
	
