extends Area2D
#DO NOT USE THIS, USE OBJECT INTERACT INSTEAD
@export var doThis : String = "asdf"

signal bob

func _on_Interact_body_entered(body):
	emit_signal("bob")
	print("bob emited!")


func _on_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	print(area)
	pass # Replace with function body.
