class_name Entity extends CharacterBody2D

@export var time_to_disappear_in_dark: float = 2

var _time_left_to_disappear: float = 0
var _in_light = false

# Variables for zombie sounds
var _zombieSoundTimer = 0
var _resetzombieSoundTimer = 0.5

@onready var zombieEmitter3D = get_node("../../SpatialAudio3D/ZombieSounds_FmodEventEmitter3D")
var scaleEmitter = 0.015

func _ready():
	print("Entity Ready")
	LightArea2DManager.light_area_entered.connect(_on_light_area_entered)
	LightArea2DManager.light_area_exited.connect(_on_light_area_exited)
	
	modulate.a = 0
	visible = false

func _process(delta: float) -> void:
	zombieEmitter3D.global_transform.origin = Vector3(global_position.x*scaleEmitter, 0.0, global_position.y*scaleEmitter)
	
	if _in_light: return
	_time_left_to_disappear -= delta
	_time_left_to_disappear = max(0, _time_left_to_disappear)
	modulate.a = _time_left_to_disappear / time_to_disappear_in_dark
	if _time_left_to_disappear == 0:
		modulate.a = 0
		visible = false

func _on_light_area_entered(body):
	if body != self: return
	modulate.a = 1
	visible = true
	_in_light = true

func _on_light_area_exited(body):
	if body != self: return
	_time_left_to_disappear = time_to_disappear_in_dark
	_in_light = false
	
func _start_playing_sounds():
	zombieEmitter3D.play()
	_zombieSoundTimer = randf_range(1.5, 3)
	$Timer_Groans.start(_zombieSoundTimer)

func _on_timer_groans_timeout() -> void:
	_start_playing_sounds()
	
func _stop_playing_sounds():
	zombieEmitter3D.stop()
	$Timer_Groans.stop()
	
