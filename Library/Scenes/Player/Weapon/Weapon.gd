extends Node2D

@onready var gatling = $Gatling_Gun
@onready var bullet_weapon = preload("res://Library/Scenes/Player/Weapon/Gatling_Gun/Gatling_Bullet.tscn")
var bullet_speed = 1000

var beam
var homing
var wave



var current_weapon = "gatling"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_current_weapon():
	return current_weapon
	
func set_current_weapon(new_weapon):
	current_weapon = current_weapon
	pass




func shoot():
	match current_weapon:
		"gatling":
		# code for gatling weapon
			var thisBullet = bullet_weapon.instantiate()
			thisBullet.position = get_parent().get_global_position()
			var rotation_relative = get_parent().get_parent().rotation
			var forward_vector = Vector2(cos(rotation_relative), sin(rotation_relative))
			thisBullet.linear_velocity = forward_vector * bullet_speed
			thisBullet.myParent = self.get_parent()
			
			get_tree().get_root().add_child(thisBullet)
			thisBullet.rotation = rotation_relative
			#thisBullet.apply_impulse(Vector2(), Vector2(bullet_speed, 0).rotated(rotation_Relative))

			#print(Vector2(bullet_speed, 0).rotated(rotation))
		"beam":
		# code for beam weapon
			var thisBullet = bullet_weapon.instantiate()
			thisBullet.position = get_parent().get_global_position()
			var rotation_relative = get_parent().get_parent().rotation
			var forward_vector = Vector2(cos(rotation_relative), sin(rotation_relative))
			thisBullet.linear_velocity = forward_vector * bullet_speed
			get_tree().get_root().add_child(thisBullet)
			thisBullet.rotation = rotation_relative
			print("Beam weapon selected")
		"homing":
		# code for homing weapon
			print("Homing weapon selected")
		"wave":
		# code for wave weapon
			print("Wave weapon selected")
		_:
		# default code if none of the above cases match
			print("Invalid weapon type")


func swapToNext():
	#this will need to be adjusted for when weapons are unlocks. 
	match current_weapon:
		"gatling":
			current_weapon = "beam"
		"beam":
		# code for beam weapon
			current_weapon = "homing"
		"homing":
		# code for homing weapon
			current_weapon = "wave"
		"wave":
			current_weapon = "gatling"
		_:
		# default code if none of the above cases match
			print("Invalid weapon type")



func shootGatling():
	pass

