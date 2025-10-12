class_name Player extends CharacterBody2D

## How far the player hand can move away from the hand start position.
const MAX_HAND_DISTANCE: float = 12
## When the player hits a RB, that isn't a door, how much should the velocity transfer to an impulse to that RB?
const VEL_TO_RB_FORCE_RATIO: float = 0.3

@export var _animator: AnimatedSprite2D
@export var _stamina_bar: AutohideProgressBar
@export var _player_camera: PlayerCamera
@export var _rb_interactor: Area2D
@export var _player_hand: Node2D
@export var _walk_speed : float = 50
@export var _run_speed : float = 70
@export var _total_stamina : float = 5

@onready var _stamina_left = _total_stamina
# The starting offset of the hand, relative to the player.
@onready var _hand_offset : Vector2 = Vector2.ZERO

@onready var _camera_zoom = _player_camera.zoom
var _is_running: bool = false

func _ready() -> void:
	Game.set_player_mental_state(Game.PlayerMentalState.IN_DANGER)
	
	_player_camera.position = position
	_hand_offset = _player_hand.position
	
	add_to_group("Player")
	_rb_interactor.body_shape_entered.connect(_on_body_shape_entered)


func _process(delta: float) -> void:
	_update_ui()
	
	#region Update camera position
	var target_pos = position - get_global_mouse_position()
	_player_camera.position = position
	_player_hand.look_at(get_global_mouse_position())
	if _is_running:
		_player_camera.zoom = _camera_zoom * 0.9
	else:
		_player_camera.zoom = _camera_zoom
	#endregion
	
	#region Update hand position
	var hand_dir = -target_pos.normalized()
	var hand_dist = -target_pos / 20
	hand_dist = clamp(hand_dist.length(), -MAX_HAND_DISTANCE, MAX_HAND_DISTANCE)
	
	_player_hand.position = (hand_dir * hand_dist) + _hand_offset
	#endregion
	
	#region Reflect direction in player sprite
	if hand_dir.x > 0:
		_player_hand.scale.y = 1
		_animator.flip_h = false
	else:
		_player_hand.scale.y = -1
		_animator.flip_h = true
	#endregion
	#
	#if Input.is_action_just_pressed("action"):
		#var hitbox = HitBox.create(self)
		#hitbox.position = _player_hand.position
		#hitbox.look_at(get_global_mouse_position())

func _update_ui():
	_stamina_bar.set_value_bar((_stamina_left / _total_stamina) * 100)

func _physics_process(delta: float) -> void:
	var dir_x = Input.get_axis("move_left", "move_right")
	var dir_y = Input.get_axis("move_up", "move_down")
	var dir = Vector2(dir_x, dir_y)
	var speed = _walk_speed
	#region Stamina consumption.
	if Input.is_action_just_pressed("run") && dir != Vector2.ZERO &&  _stamina_left > 0:
		_is_running = true
	if Input.is_action_just_released("run"):
		_is_running = false
	
	if _is_running:
		_stamina_left -= delta * Game.get_stamina_consumption_rate()
		speed = _run_speed
		
		if _stamina_left <= 0:
			_is_running = false
	else:
		_stamina_left += delta
	#endregion
	_stamina_left = clamp(_stamina_left, 0, _total_stamina)
	velocity = dir * speed
	move_and_slide()
	
	for body in _rb_interactor.get_overlapping_bodies():
		if !body.is_in_group("Door"): continue
		body.apply_central_force(velocity * 1.5 - (-velocity.normalized() * body.mass))
		if _is_running:
			body.apply_central_impulse(velocity * 0.5 - (-velocity.normalized() * body.mass))

func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body:
		var col = body.shape_owner_get_owner(body.shape_find_owner(body_shape_index))
		var col_normal = position.direction_to(body.position)
		var col_pos = position - body.position
		if body is RigidBody2D:
			if !body.is_in_group("Door"):
				body.apply_impulse(velocity.length() * VEL_TO_RB_FORCE_RATIO * (col_normal * body.mass), col_pos)
			
