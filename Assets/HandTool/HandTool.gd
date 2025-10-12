class_name HandTool extends Node2D

var _is_enabled = false

func activate():
	if !_is_enabled:
		return

func enable():
	visible = true
	_is_enabled = true

func disable():
	visible = false
	_is_enabled = false
