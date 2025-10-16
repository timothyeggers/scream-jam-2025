class_name LanternTool extends HandTool

@export var light: Light2D
@export var shadow: Light2D
@export var light_area: LightArea2D


func enable():
	super()
	light.enabled = true
	shadow.enabled = true
	light_area.monitorable = true
	light_area.monitoring = true

func disable():
	super()
	light.enabled = false
	shadow.enabled = false
	light_area.monitorable = false
	light_area.monitoring = false
