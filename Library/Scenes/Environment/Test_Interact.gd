extends Node2D

onready var sprite = $Sprite
var colour = Color.red
var target_scene = preload("res://Library/Scenes/Environment/Interact.tscn")


func _ready():
	var interact_node = target_scene.instance()
	interact_node.connect("bob", self, "doInteract")

func doInteract():
	print("asd")
	sprite.modulate = colour


func _on_action():
	doInteract()
