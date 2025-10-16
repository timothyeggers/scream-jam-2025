class_name Trader extends InteractionNode2D

@export var static_body: StaticBody2D
@export var condition_met: bool = true
@export var condition_callback: String = "has_three_apples"
@export var dialog: String = "If you bring me three apples, I will let you pass..."
@export var dialog_label: Label

var _activated_once: bool = false
var _can_talk_again: bool = true
var _is_dying: bool = false
var _dying_fadeout_time: float = 2
var _dying_dt: float = 0

func _process(delta):
	super(delta)
	if !_is_dying: return
	
	_dying_dt += delta
	if _dying_dt >= _dying_fadeout_time:
		queue_free()

func activate() -> void:
	super()
	if !_activated_once:
		_activated_once = true
		type_dialog()
		return
	if !condition_met:
		if !_can_talk_again: return
		var condition = Inventory.call(condition_callback)
		if !condition:
			type_dialog()
			return
		type_dialog("Thank you...")
		var tween = create_tween()
		tween.tween_property(self, "modulate:a", 0.0, _dying_fadeout_time)
		_is_dying = true
	condition_met = true
#	static_body.collision_layer = 0

func type_dialog(text: String = dialog):
	if !_can_talk_again: return
	_can_talk_again = false
	dialog_label.text = ""
	for char in text:
		dialog_label.text += char
		await get_tree().create_timer(0.1).timeout
	_can_talk_again = true
