class_name EntityStunnedState extends EntityState

@export var stun_time : float = 1
@export var stun_icon : Sprite2D

@onready var _stun_icon_scale = stun_icon.scale
var _stun_dt : float = 0.0

func enter():
	_stun_dt = 0.0
	stun_icon.scale = _stun_icon_scale
	var tween = create_tween().set_parallel(true)
	tween.tween_property(stun_icon, "scale", stun_icon.scale * 0, stun_time)
	stun_icon.show()

func exit():
	stun_icon.hide()

func _process(delta: float) -> void:
	_stun_dt += delta
	if _stun_dt > stun_time:
		emit_signal("transitioned", self, "EntityFleeState")
		
