extends Line2D


var growth_speed = 10
var start_pos = Vector2.ZERO
var direction = Vector2(1, 0)
var max_length = 100
var distance_traveled = 0
var raycast = null

func _ready():
	set_process(true)
	set_points([start_pos, start_pos])
	raycast = RayCast2D.new()
	add_child(raycast)
	raycast.enabled = false

func _process(delta):
	if distance_traveled < max_length:
		distance_traveled += delta * growth_speed
		var end_pos = start_pos + direction * distance_traveled
		raycast.enabled = true
		raycast.target_position = end_pos - start_pos
		raycast.position = start_pos
		if raycast.is_colliding():
			end_pos = raycast.get_collision_point()
			distance_traveled = start_pos.distance_to(end_pos)
		set_points([start_pos, end_pos])
	else:
		var end_pos = start_pos + direction * max_length
		set_points([start_pos, end_pos])
