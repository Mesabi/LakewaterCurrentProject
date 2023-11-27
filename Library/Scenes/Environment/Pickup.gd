extends Area2D


enum PickupType {
	TEST,
	AMMO_G,
	AMMO_B,
	KEY_A,
}
#I'm doing this as an enum mostly for ease in the editor. 
@export var item = PickupType.AMMO_G #this will be set to a list of default actions via export. 


func do_Pickup(body):
	match item:
		PickupType.TEST:
			body.get_parent().do_Pickup("TEST")
		PickupType.AMMO_G:
			body.get_parent().do_Pickup("ReloadG")
		_:
			pass
	queue_free()


func _on_Pickup_body_entered(body):
	if(body.is_in_group("Player")):
		do_Pickup(body)
	pass # Replace with function body.


func _on_Pickup_area_entered(area):
	#this isn't the one that's working
	print(area)
	pass # Replace with function body.
