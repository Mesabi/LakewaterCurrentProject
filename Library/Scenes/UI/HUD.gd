extends Control


@onready var healthCount = $Main_Panel/Center/Health_Count
@onready var objectiveField = $Main_Panel/Center/Objective_Field

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.




func updateHealth(amt):
	healthCount.text = str(amt)
	
func updateObjective(here):
	objectiveField.text = str(here)
