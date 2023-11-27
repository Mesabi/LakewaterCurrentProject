extends Node2D

@export var healthPack = 0
# Declare member variables here. Examples:
@export var gatlingAmmo = 0
@export var beamAmmo = 0
@export var homingAmmo = 0
@export var waveAmmo = 0
@export var missiles = 0



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func addItem(type, amount):
	match type:
		"gatlingAmmo":
			gatlingAmmo += amount
		"beamAmmo":
			beamAmmo += amount
			pass
		"homingAmmo":
			homingAmmo += amount
			pass
		"waveAmmo":
			waveAmmo += amount
			pass
		"":
			waveAmmo += amount
			pass
		"missiles":
			missiles += amount
			pass
		_:
			print("no such item "+ type)


