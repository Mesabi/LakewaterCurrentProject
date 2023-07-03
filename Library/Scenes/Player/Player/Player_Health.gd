extends Node2D


export var points : int = 100
export var isDead = false

export var hasMax = false
export var pointMax = 100


func setHealth(amt):
	#
	points = int(amt)
	isDead = false


func deductHealth(amt):
	points -= amt
	if(points < 0):
		isDead = true
	return isDead
	
func addHealth(amt):
	points += amt
	
func resurrect(amt):
	points = amt
	isDead = false
	
