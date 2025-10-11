class_name EntityFleeState extends EntityState

@export var move_speed: float = 75
@export var flee_time: float = 4

var _flee_dt = 0

func enter():
	_flee_dt = 0

func _process(delta: float) -> void:
	_flee_dt += delta
	if _flee_dt >= flee_time:
		emit_signal("transitioned", self, "EntityWanderState")

func physics_process(delta):
	var move_dir = body.global_position.direction_to(Game.get_player().global_position)
	body.velocity = -move_dir * move_speed
	body.move_and_slide()
	
	# flip character
	if move_dir.x > 0:
		sprite.scale.x = abs(sprite.scale.x)
	elif move_dir.x < 0:
		sprite.scale.x = abs(sprite.scale.x) * -1
		
