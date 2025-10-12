class_name ToolState extends State

@export var tool: HandTool

func enter():
	if tool: tool.enable()
	
func exit():
	if tool: tool.disable()

func process(delta):
	if Input.is_action_just_pressed("action") && Inventory.glow_sticks > 0:
		if tool: 
			tool.activate()
			Inventory.glow_sticks -= 1
