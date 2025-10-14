class_name EntityChaseState extends EntityState

@export var move_speed: float = 60
@export var attack_distance: float = 25

func enter():
	entity.light_area_entered.connect(_on_light_area_entered)
	entity.light_area_exited.connect(_on_light_area_exited)

func exit():
	entity.light_area_entered.disconnect(_on_light_area_entered)
	entity.light_area_exited.disconnect(_on_light_area_exited)

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
	var move_dir = entity.global_position.direction_to(Game.get_player().global_position)
	entity.velocity = move_dir * move_speed
	entity.move_and_slide()
	
	# flip character
	if move_dir.x > 0:
		sprite.scale.x = abs(sprite.scale.x)
	elif move_dir.x < 0:
		sprite.scale.x = abs(sprite.scale.x) * -1
