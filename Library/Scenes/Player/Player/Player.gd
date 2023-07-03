extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var weapon = $Firepoint/Weapon


export var speed = 10
export var break_speed = 20
var rotation_self = 0
export var rotation_speed = .5
var velocity = Vector2()
var weapons_free = false
var bullet_speed = 2000
onready var bullet_weapon = preload("res://Library/Scenes/Player/Weapon/Gatling_Gun/Gatling_Bullet.tscn")
var raycasts = [] # Keep track of all the raycasts we create

# Called when the node enters the scene tree for the first time.
func _ready():
	print(self.position)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#get_input()
	move(delta)


func move(delta):
	rotation += rotation_self * rotation_speed * delta
	var collide = move_and_collide(velocity * delta)
	if(collide != null):
		#print(collide.get_collider())
		handle_Collision(collide)

func handle_Collision(collide):
	
	var Colliding_Object = collide.get_collider()
	var collision_normal = collide.get_normal()
	
	if(Colliding_Object.is_in_group("TEST")):
		print("Object is in group test!!!")
	if(Colliding_Object.is_in_group("Repell")):
		#needs more nuance. Fix later
		
		
		velocity = velocity.rotated(self.rotation-PI)* .9
		#velocity = velocity * .9
		get_parent().harmSelf(1)
	if(Colliding_Object.is_in_group("Damage")):
		get_parent().harmSelf(collide.getDamage())
	








func get_input():
	handle_rotation()
	handle_forward_back()
	#handle_weapons()



func test():
	#test block for raycasts:
	if(Input.is_action_just_pressed("toggle")):
		var raycast = RayCast2D.new()
		add_child(raycast)
		raycast.cast_to = Vector2(0, 100) # Set the direction of the raycast
		raycast.add_exception(self) # Exclude the object that the raycast is attached to
		raycast.add_exception($Firepoint)
		print("fire!")
		raycasts.append(raycast) # Add the new raycast to the list
	for raycast in raycasts:
		raycast.force_raycast_update()
		if raycast.is_colliding():
			print("Hit location: ", raycast.get_collision_point())



func shoot():
	weapon.shoot()




func handle_weapons():
	#handles shooting weapons, on off toggle, missile.
	if(Input.is_action_just_pressed("toggle")):
		if(!weapons_free):
			weapons_free = true
			print("weapons free!")
		else:
			weapons_free = false
	if(Input.is_action_pressed("fire_weapon")):
		
		
		
		
		
		
		

		if(weapons_free):
			#set to firepoint.
			var thisBullet = bullet_weapon.instance()
			#thisBullet.apply_impulse(rotation_self)
			thisBullet.position = get_node("Firepoint").global_position
			thisBullet.rotation_degrees = self.rotation_degrees
			thisBullet.apply_impulse(Vector2(), Vector2(bullet_speed, 0).rotated(rotation))
			#consider changing this when UI is added to get_root
			get_parent().add_child(thisBullet)
			pass
			
		else:
			print("open weapons")


func handle_forward_back():
	#handles moving the ship up and down. 
	if (Input.is_action_pressed("ui_up")):
		velocity += Vector2(speed, 0).rotated(rotation)
	if (Input.is_action_pressed("ui_down")):
		slow_to_stop()
		
func slow_to_stop():
	#slowly brakes the ship.
	if(velocity != Vector2.ZERO):
		velocity -= velocity / break_speed
	if(velocity.length() < 1):
		velocity = Vector2.ZERO

func handle_rotation():
	#handles rotation. NOTE the ship faces right in the editor. 
	var rotation_temp = rotation_self
	if(rotation_temp != 0):
		if(rotation_temp > 0):
			rotation_temp -= .1
		else:
			rotation_temp += .1
		rotation_self = rotation_temp
	if (Input.is_action_pressed("ui_left")):
		rotation_self -= rotation_speed
	if (Input.is_action_pressed("ui_right")):
		rotation_self += rotation_speed
		
		
