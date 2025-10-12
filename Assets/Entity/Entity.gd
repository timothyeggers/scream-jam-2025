class_name Entity extends CharacterBody2D

signal light_area_entered(light_area_2d)
signal light_area_exited(light_area_2d)

@export var time_to_disappear_in_dark: float = 2

var _time_left_to_disappear: float = 0
var _in_light = false

func _ready():
	light_area_entered.connect(_on_light_area_entered)
	light_area_exited.connect(_on_light_area_exited)
	
	modulate.a = 0
	visible = false

func _process(delta: float) -> void:
	if _in_light: return
	_time_left_to_disappear -= delta
	_time_left_to_disappear = max(0, _time_left_to_disappear)
	modulate.a = _time_left_to_disappear / time_to_disappear_in_dark
	if _time_left_to_disappear == 0:
		modulate.a = 0
		visible = false

func _on_light_area_entered(light_area_2d):
	modulate.a = 1
	visible = true
	_in_light = true

func _on_light_area_exited(light_area_2d):
	_time_left_to_disappear = time_to_disappear_in_dark
	_in_light = false
