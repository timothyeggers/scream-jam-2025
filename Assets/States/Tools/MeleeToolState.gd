class_name MeleeToolState extends ToolState

func enter():
	if tool: tool.enable()
	
func exit():
	if tool: tool.disable()

func process(delta):
		#if Input.is_action_just_pressed("action"):
		#var hitbox = HitBox.create(self)
		#hitbox.position = _player_hand.position
		#hitbox.look_at(get_global_mouse_position())
	
	if !Input.is_action_just_pressed("action"):
		return
	
	super(delta)
