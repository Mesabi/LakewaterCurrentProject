extends Node2D

@onready var sprite = $Sprite2D
var colour = Color.RED
var target_scene = preload("res://Library/Scenes/Environment/Interact.tscn")


func _ready():
	var interact_node = target_scene.instantiate()
	interact_node.connect("bob", Callable(self, "doInteract"))

func doInteract():
	print("asd")
	sprite.modulate = colour


func _on_action():
	doInteract()
