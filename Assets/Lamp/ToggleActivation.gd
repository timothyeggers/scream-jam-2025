class_name ToggleActivation extends Node2D

@export var start_off = true

func _ready():
	if start_off:
		hide()

func activate():
	show()

func deactivate():
	hide()
