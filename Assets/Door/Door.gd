extends RigidBody2D

@export var max_degrees_offset: float = 90

@onready var _start_degrees = rotation_degrees
@onready var _start_pos = position

func _physics_process(delta: float) -> void:
	rotation_degrees = clamp(rotation_degrees, _start_degrees - max_degrees_offset, _start_degrees + max_degrees_offset)
	#position = _start_pos
