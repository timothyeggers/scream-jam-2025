extends PointLight2D

func _ready():
	var tween = create_tween().set_parallel(true)
	tween.tween_property(self, "scale", 0.8, 1.0)

func _process(delta: float) -> void:
	if randf() > 0.99:
		hide()
	else:
		show()
