class_name Door extends CharacterBody2D

@export var max_degrees_offset: float = 90

@onready var _start_degrees = rotation_degrees

var _is_open: bool = false
var _can_open: bool = true

func toggle(dir_x: int):
	if !_can_open: return
	_can_open = false
	if _is_open:
		rotation_degrees = _start_degrees
	else:
		rotation_degrees = max_degrees_offset * dir_x
	await get_tree().create_timer(0.25).timeout
	_can_open = true
