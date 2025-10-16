class_name LockedDoor extends InteractionNode2D

@export var static_body: StaticBody2D
@export var open_toward: float = 90
@export var condition_met: bool = true
@export var condition_callback: String = "has_yellow_key"

@onready var _coll_layer = static_body.collision_layer

var _is_open: bool = false

func activate() -> void:
	super()
	if !condition_met:
		var condition = Inventory.call(condition_callback)
		if !condition:
			return
		Game.ui.log_message("Unlocked!")
	if _is_open: 
		deactivate()
		return
	condition_met = true
	static_body.collision_layer = 0
	sprite.rotation_degrees = open_toward
	_is_open = true

func deactivate() -> void:
	static_body.collision_layer = _coll_layer
	sprite.rotation_degrees = 0
	_is_open = false
