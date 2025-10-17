class_name EntityWanderState extends EntityState

@export var move_speed : float = 25
@export var wander_radius: float = 35
@export var wander_timeout: float = 2
@export var detector: Area2D
@export var timer: Timer

var _start_pos: Vector2

func _ready():
	_start_pos = entity.global_position

func _on_player_entered(body):
	if body is not Player: return
	
	emit_signal("transitioned", self, "EntityChaseState")

func set_target_position():
	navigation.target_position = get_random_wander_position()
	timer.start(0)

func get_random_wander_position():
	var random_x = randf_range(-wander_radius, wander_radius) + _start_pos.x
	var random_y = randf_range(-wander_radius, wander_radius) + _start_pos.y
	return Vector2(random_x, random_y)

func enter():
	_start_pos = entity.global_position
	set_target_position()
	detector.body_entered.connect(_on_player_entered)
	navigation.velocity_computed.connect(Callable(_on_velocity_computed))
	timer.wait_time = wander_timeout
	timer.timeout.connect(set_target_position)
	timer.start()

func exit():
	detector.body_entered.disconnect(_on_player_entered)
	navigation.velocity_computed.disconnect(Callable(_on_velocity_computed))
	timer.timeout.disconnect(set_target_position)

func physics_process(delta):
	if navigation.is_navigation_finished():
		set_target_position()
	
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
