extends Node2D



var heat = 0
var maxHeat = 100


# Declare member variables here. Examples:
var bullet = preload("res://Library/Scenes/Player/Weapon/Gatling_Gun/Gatling_Bullet.tscn")
@export var bullet_speed = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func shoot(rotation, firepoint):
	#set to firepoint.
	var thisBullet = bullet.instantiate()
	thisBullet.position = firepoint
	thisBullet.rotation_degrees = self.rotation_degrees
	thisBullet.apply_impulse(Vector2(bullet_speed, 0).rotated(rotation), Vector2())
	#consider changing this when UI is added to get_root
	get_parent().add_child(thisBullet)
