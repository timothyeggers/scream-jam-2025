class_name EntityChaseState extends EntityState

@export var move_speed: float = 60

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("debug_stun"):
		emit_signal("transitioned", self, "EntityStunnedState")

func physics_process(delta):
	var move_dir = body.global_position.direction_to(Game.get_player().global_position)
	body.velocity = move_dir * move_speed
	body.move_and_slide()
	
	# flip character
	if move_dir.x > 0:
		sprite.scale.x = abs(sprite.scale.x)
	elif move_dir.x < 0:
		sprite.scale.x = abs(sprite.scale.x) * -1
