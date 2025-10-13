class_name ToolState extends State

@export var tool: HandTool

func enter():
	if tool: tool.enable()
	
func exit():
	if tool: tool.disable()

func process(delta):
	if Input.is_action_just_pressed("action"):
		if tool: 
			tool.activate()
