class_name GlowStick extends RigidBody2D

const SCENE_PATH: NodePath = "res://Assets/GlowStick/GlowStick.tscn"

@export var light: PointLight2D
@export var time_alive: float = 10

var _time_left: float = 0

static func create(attach_to: Node) -> GlowStick:
	if !attach_to || !is_instance_valid(attach_to) || attach_to.is_queued_for_deletion():
		return
	
	var s = load(SCENE_PATH)
	var control: GlowStick = s.instantiate()
	
	attach_to.add_child(control)
	
	return control

func _process(delta: float) -> void:
	_time_left += delta
	if _time_left >= time_alive:
		if light:
			light.enabled = false
		queue_free()
