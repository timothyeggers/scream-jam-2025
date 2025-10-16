class_name Player extends CharacterBody2D

## How far the player hand can move away from the hand start position.
const MAX_HAND_DISTANCE: float = 12
## When the player hits a RB, that isn't a door, how much should the velocity transfer to an impulse to that RB?
const VEL_TO_RB_FORCE_RATIO: float = 0.3

@export var _walk_speed : float = 50
@export var _run_speed : float = 70
@export var _total_stamina : float = 5
## when you reach _health 0 you die immediately, so u really only have 3 hits until dead
@export var _health: float = 4
@export var _damage_cooldown: float = 1

@export_category("Internal")
@export var _animator: AnimatedSprite2D
@export var _stamina_bar: AutohideProgressBar
@export var _player_camera: PlayerCamera
@export var _interactor: Area2D
@export var _player_hand: Node2D
@export var _attack_sprite: Sprite2D
@export var _blood_emitter: CPUParticles2D

@onready var _stamina_left = _total_stamina
# The starting offset of the hand, relative to the player.
@onready var _hand_offset : Vector2 = Vector2.ZERO

@onready var _camera_zoom = _player_camera.zoom
var _is_running: bool = false
var _damage_cd: float = 0
var _facing_dir: Vector2 = Vector2.DOWN

# Variables for footsteps sounds
var _footstepTimer = 0
var _resetfootstepTimer = 0.3

@onready var musicEmitter = get_node("../../SpatialAudio3D/Music_Emitter")
@onready var listener3d = get_node("../../SpatialAudio3D/FmodListener3D")
@onready var footstepsEmitter3d = get_node("../../SpatialAudio3D/Footsteps_FmodEmitter3D")
@onready var playerHitEmitter3d = get_node("../../SpatialAudio3D/Player_Hit")
var scaleListener = 0.015

func _ready() -> void:
	Game.set_player_mental_state(Game.PlayerMentalState.IN_DANGER)
	FmodServer.add_listener(0,listener3d)
	_player_camera.position = position
	_hand_offset = _player_hand.position
	musicEmitter.play()
	add_to_group("Player")
	_interactor.body_shape_entered.connect(_on_body_shape_entered)


@onready var walk_speed = _walk_speed
func _process(delta: float) -> void:
	_update_ui()
	
	if Input.is_action_just_pressed("debug_start_chase"):
		_walk_speed = walk_speed * 3
	if Input.is_action_just_pressed("debug_stun"):
		_walk_speed = walk_speed
	
	listener3d.global_transform.origin = Vector3(global_position.x*scaleListener, 0.0, global_position.y*scaleListener)
	
	if _damage_cd > 0:
		_damage_cd -= delta
	
	#region Update camera position
	var target_pos = position - get_global_mouse_position()
	_player_camera.position = position
	if _is_running:
		_player_camera.zoom = _camera_zoom * 0.9
	else:
		_player_camera.zoom = _camera_zoom
	#endregion
	
	#region Update hand position
	var target_hand_pos = _animator.get_global_transform().get_origin() - get_global_mouse_position()
	var hand_dir = -target_hand_pos.normalized()
	var hand_dist = -target_hand_pos / 20
	if hand_dist.length() > 0.3:
		_player_hand.look_at(get_global_mouse_position())
		hand_dist = clamp(hand_dist.length(), -MAX_HAND_DISTANCE, MAX_HAND_DISTANCE)
		_player_hand.position = (hand_dir * hand_dist) + _hand_offset
	#endregion
	
	#region Reflect direction in player sprite
	if target_pos.x < 0:
		_player_hand.scale.y = 1
	elif target_pos.x > 0:
		_player_hand.scale.y = -1

	var hor_priority = true if abs(target_pos.x) > abs(target_pos.y) else false
	if velocity.x != 0 && velocity.y == 0:
		hor_priority = true
	if velocity.x == 0 && velocity.y != 0:
		hor_priority = false
	if hor_priority:
		if target_pos.x < 0:
			_animator.play("walk_right")
			_facing_dir = Vector2.RIGHT
		elif target_pos.x > 0:
			_animator.play("walk_left")
			_facing_dir = Vector2.LEFT
	else:
		if target_pos.y > 0:
			_animator.play("walk_up")
			_facing_dir = Vector2.UP
		elif target_pos.y < 0:
			_animator.play("walk_down")
			_facing_dir = Vector2.DOWN
	
	if velocity.length() == 0:
		_animator.frame = 0
		_animator.pause()
	#endregion

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
		_animator.speed_scale = 1.25
		
		if _stamina_left <= 0:
			_is_running = false
	else:
		_stamina_left += delta
		_animator.speed_scale = 1
	#endregion
	_stamina_left = clamp(_stamina_left, 0, _total_stamina)
	velocity = dir * speed
	
	if dir:
		if _footstepTimer <= 0:
			footstepsEmitter3d.play()
			if _is_running:
				footstepsEmitter3d.set_parameter("Pitch_Footsteps", 1)
				_footstepTimer = _resetfootstepTimer / 1.1
			else:
				footstepsEmitter3d.set_parameter("Pitch_Footsteps", 0)
				_footstepTimer = _resetfootstepTimer
		_footstepTimer -= delta
	move_and_slide()
	
	#for body in _rb_interactor.get_overlapping_bodies():
		#if !body.is_in_group("Door") && body is not RigidBody2D: continue
		#body.apply_central_force(velocity * 1.5 - (-velocity.normalized() * body.mass))
		#if _is_running:
			#body.apply_central_impulse(velocity * 0.5 - (-velocity.normalized() * body.mass))

func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body:
		var col = body.shape_owner_get_owner(body.shape_find_owner(body_shape_index))
		var col_normal = position.direction_to(body.position)
		var col_pos = position - body.position
		if body.is_in_group("Door"):
			if body is Door:
				var dir_to = -1 if global_position.x < body.global_position.x else 1
				#body.toggle(dir_to)

func take_damage(amount: int):
	if _damage_cd > 0: return
	_damage_cd = _damage_cooldown
	_health -= amount
	_attack_sprite.show()
	_blood_emitter.emitting = true
	playerHitEmitter3d.play_one_shot()
	var tween = create_tween()
	_attack_sprite.modulate.a = 1
	tween.tween_property(_attack_sprite, "modulate:a", 0, 1).set_ease(Tween.EASE_OUT)
	if _health <= 0:
		Game.player_died.emit()
