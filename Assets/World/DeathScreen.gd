extends Camera2D

func _process(delta: float) -> void:
	if !enabled: return
	
	if Input.is_action_pressed("reset"):
		Game.reset_game()
