extends Node2D

@onready var left = $AttackPosLeft
@onready var right = $AttackPosRight
var attackObj : PackedScene = preload("res://Library/Scenes/Player/Weapon/Sword/StillAttack.tscn")
var damage = 10
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func attack(isLeft):
	var hit : Node = attackObj.instantiate()
	hit._set_Up_Self(damage, get_parent().velocity)
	#hit.
	if(isLeft):
		#use pos = pos here, globals break this for some reason.
		hit.position = left.position
	else:
		hit.position = right.position
	self.add_child(hit)


	pass
