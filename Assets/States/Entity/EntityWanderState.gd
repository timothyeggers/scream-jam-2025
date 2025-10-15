class_name EntityWanderState extends EntityState

@export var move_speed : float = 25
@export var wander_radius: float = 35
@export var detector: Area2D

var _start_pos: Vector2
var _target_pos: Vector2

func _ready():
	_start_pos = entity.position
	detector.body_entered.connect(_on_player_entered)

func _on_player_entered(body):
	if body is not Player: return
	
	emit_signal("transitioned", self, "EntityChaseState")

func set_target_position(pos: Vector2):
	_target_pos = pos
	navigation.target_position = pos

func get_random_position():
	var random_x = randf_range(-wander_radius, wander_radius) + _start_pos.x
	var random_y = randf_range(-wander_radius, wander_radius) + _start_pos.y
	return Vector2(random_x, random_y)

func enter():
	_start_pos = entity.position
	#set_target_position(get_random_position())
	set_target_position(entity.position + (Vector2.LEFT * 100))

func physics_process(delta):
	if navigation.is_navigation_finished():
		set_target_position(get_random_position())
	
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
