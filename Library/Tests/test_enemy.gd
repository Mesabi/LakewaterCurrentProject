extends Node2D

@onready var _anim = $Enemy/AnimationPlayer
@onready var enemySelf = $Enemy
@onready var label = $Label

# Called when the node enters the scene tree for the first time.
func _ready():
	#player.play("Idle")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.global_position = enemySelf.global_position#move this to enemy
	label.text = str(enemySelf.state)
	pass
