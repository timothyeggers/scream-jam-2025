class_name EntityChaseState extends EntityState

@export var move_speed: float = 60
@export var attack_distance: float = 25
@export var timer: Timer
@export var chase_wait_time: float = 0.25

func set_target_position():
	navigation.target_position = Game.get_player().global_position
	timer.start(0)

func enter():
	print("test1")
	entity._start_playing_sounds()
	entity.light_area_entered.connect(_on_light_area_entered)
	entity.light_area_exited.connect(_on_light_area_exited)
	navigation.velocity_computed.connect(Callable(_on_velocity_computed))
	timer.wait_time = chase_wait_time
	timer.timeout.connect(set_target_position)
	timer.start()

func exit():
	entity._stop_playing_sounds()
	entity.light_area_entered.disconnect(_on_light_area_entered)
	entity.light_area_exited.disconnect(_on_light_area_exited)
	navigation.velocity_computed.disconnect(Callable(_on_velocity_computed))
	timer.timeout.disconnect(set_target_position)

func _on_light_area_entered(light_area_2d):
	if light_area_2d is LightArea2D:
		if light_area_2d.is_harmful:
			emit_signal("transitioned", self, "EntityStunnedState")

func _on_light_area_exited(light_area_2d):
	pass

func process(delta):
	if entity.global_position.distance_to(Game.get_player().global_position) <= attack_distance:
		Game.get_player().take_damage(1)

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
