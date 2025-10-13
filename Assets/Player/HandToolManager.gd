class_name HandToolManager extends Node2D

var _tools: Array[HandTool] = []

func _ready():
	for tool in get_children():
		if tool is HandTool:
			_tools.append(tool)
			tool.disable()
