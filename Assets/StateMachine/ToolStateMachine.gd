class_name ToolStateMachine extends StateMachine

var index: int = 0

func _process(delta: float) -> void:
	super(delta)
	
	if Input.is_action_just_pressed("scroll_down"):
		index += 1
		if index >= states.keys().size():
			index = 0
		var keyname = states.keys()[index]
		transition(keyname)
	
	if Input.is_action_just_pressed("scroll_up"):
		index -= 1
		if index < 0:
			index = states.keys().size() - 1
		var keyname = states.keys()[index]
		transition(keyname)
