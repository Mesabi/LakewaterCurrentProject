extends Area2D
#DO NOT USE THIS, USE OBJECT INTERACT INSTEAD
@export var doThis : String = "asdf"

signal bob

func _on_Interact_body_entered(body):
	emit_signal("bob")
	print("bob emited!")
