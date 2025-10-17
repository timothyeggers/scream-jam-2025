class_name EntityFleeState extends EntityState

const FLEE_DISTANCE = 500

@export var move_speed: float = 105
@export var flee_time: float = 6
@export var timer: Timer

var _start_pos: Vector2

func end_flee():
	emit_signal("transitioned", self, "EntityWanderState")

func enter():
	_start_pos = entity.global_position
	navigation.velocity_computed.connect(Callable(_on_velocity_computed))
	timer.wait_time = flee_time
	timer.timeout.connect(end_flee)
	timer.start()
	navigation.target_position = entity.global_position + (Game.get_player().global_position.direction_to(entity.global_position) * FLEE_DISTANCE)

func exit():
	navigation.velocity_computed.disconnect(Callable(_on_velocity_computed))
	timer.timeout.disconnect(end_flee)

func physics_process(delta):
	var next_path_position: Vector2 = navigation.get_next_path_position()
	var new_velocity: Vector2 = entity.global_position.direction_to(next_path_position) * move_speed
	if navigation.avoidance_enabled:
		navigation.set_velocity(new_velocity)
	else:
		_on_velocity_computed(new_velocity)
	
	if new_velocity.x > 0:
		sprite.scale.x = abs(sprite.scale.x)
	elif new_velocity.x < 0:
		sprite.scale.x = abs(sprite.scale.x) * -1

func _on_velocity_computed(safe_velocity: Vector2):
	entity.velocity = safe_velocity
	entity.move_and_slide()
