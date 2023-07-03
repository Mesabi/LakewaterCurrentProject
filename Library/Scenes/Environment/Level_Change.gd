extends Area2D

export var goHere = "res://Scenes/World/Test_Room.tscn"




func _on_Area2D_body_entered(body):
	print("does this work?")
#	Global.goto_scene(goHere)
	
	pass # Replace with function body.


func _on_Level_Change_area_entered(area):
	print(area)	
#Global.goto_scene(goHere)
	pass # Replace with function body.


func _on_Level_Change_body_entered(body):
	print(body)
#	if(body.is_in_group("Player")):
#		print("lets Go!")
	#Global.goto_scene(goHere)
	pass # Replace with function body.
