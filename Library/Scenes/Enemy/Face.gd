extends Node2D

var rot = 0



func face_player():
	self.look_at(get_node("/root/Main/Testing_Area/WorldManager/Player").global_position)
	return self.position.direction_to(get_node("/root/Main/Testing_Area/WorldManager/Player").global_position)
