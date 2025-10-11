class_name EntityWanderState extends EntityState

@export var move_speed : float = 15
@export var wander_radius: float = 15
@export var detector: Area2D

var _start_pos: Vector2
var _target_pos: Vector2

func _ready():
	_start_pos = body.position
	detector.body_entered.connect(_on_player_entered)

func _on_player_entered(body):
	if body is not Player: return
	
	emit_signal("transitioned", self, "EntityChaseState")

func set_target_position(pos: Vector2):
	_target_pos = pos

func get_random_position():
	var random_x = randf_range(-wander_radius, wander_radius) + _start_pos.x
	var random_y = randf_range(-wander_radius, wander_radius) + _start_pos.y
	return Vector2(random_x, random_y)

func enter():
	_start_pos = body.position
	set_target_position(get_random_position())

func physics_process(delta):
	var move_dir = body.global_position.direction_to(_target_pos)
	body.velocity = move_dir * move_speed
	body.move_and_slide()
	
	# flip character
	if move_dir.x > 0:
		sprite.scale.x = abs(sprite.scale.x)
	elif move_dir.x < 0:
		sprite.scale.x = abs(sprite.scale.x) * -1
	
	if body.position.distance_to(_target_pos) < 1:
		set_target_position(get_random_position())
