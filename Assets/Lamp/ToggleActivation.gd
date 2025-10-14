class_name ToggleActivation extends Node2D

@export var start_off = true
@export var light_area: LightArea2D

func _ready():
	if start_off:
		deactivate()

func activate():
	show()
	light_area.monitorable = true
	light_area.monitoring = true

func deactivate():
	hide()
	light_area.monitorable = false
	light_area.monitoring = false
