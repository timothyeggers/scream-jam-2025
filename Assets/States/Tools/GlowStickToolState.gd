class_name GlowStickToolState extends ToolState

func enter():
	if tool: tool.enable()
	
func exit():
	if tool: tool.disable()

func process(delta):
	if !Input.is_action_just_pressed("action"):
		return
	
	if Inventory.glow_sticks <= 0:
		return
	
	Inventory.glow_sticks -= 1
	
	super(delta)
