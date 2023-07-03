extends Node2D

# Letter A
onready var a = $A
# Letter B
onready var b = $B
# Letter C
onready var c = $C
# Letter D
onready var d = $D
# Letter E
onready var e = $E
# Letter F
onready var f = $F
# Letter G
onready var g = $G
# Letter H
onready var h = $H

var randomPositions

func _ready():
	var positions = [a.position, b.position, c.position, d.position, e.position, f.position, g.position, h.position]
	randomPositions = shuffleArray(positions)

func giveCrazyPath400():
	return shuffleArray(randomPositions)


func shuffleArray(array):
	var currentIndex = array.size()
	while currentIndex > 0:
		var randomIndex = randi() % currentIndex
		currentIndex -= 1
		var temp = array[currentIndex]
		array[currentIndex] = array[randomIndex]
		array[randomIndex] = temp
	return array
