class_name HitBox extends Area2D

const SCENE_PATH : NodePath = "res://Assets/HitBox/HitBox.tscn"

var time_alive : float = 0.2
var _time_alive_dt : float = 0

static func create(attach_to: Node) -> HitBox:
	if !attach_to || !is_instance_valid(attach_to) || attach_to.is_queued_for_deletion():
		return
	
	var s = load(SCENE_PATH)
	var control: HitBox = s.instantiate()
	
	attach_to.add_child(control)
	
	return control

func _process(delta: float) -> void:
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0, time_alive).set_ease(Tween.EASE_OUT)
	_time_alive_dt += delta
	if _time_alive_dt > time_alive:
		queue_free()
