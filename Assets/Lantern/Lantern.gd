extends PointLight2D

func _process(delta: float) -> void:
	if randf() > 0.99:
		hide()
	else:
		show()
