extends Node2D


@onready var EnemyManager = $Enemy_Manager
@onready var DoorManager = $Doors
@onready var NPCManager = $NPCs
@onready var PickupManager = $Pickups
@onready var CheckPoints = $Checkpoints
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func determineCheckpointValid(check) -> bool:
	#runs a pass through the checkpoints to make sure that the string checked is valid
	for Cpoint in CheckPoints.get_children():
		if check == Cpoint.checkpoint:
			return true
	return false

func getThisCheckpoint(check) -> Vector2:
	if(check == "undefined"):
		return Vector2.ZERO
	for Cpoint in CheckPoints.get_children():
		if check == Cpoint.checkpoint:
			return Cpoint.position
	return Vector2.ZERO


