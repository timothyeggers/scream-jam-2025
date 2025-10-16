class_name ItemPickup extends Area2D


const OUTLINE_MATERIAL = preload("res://Assets/OutlineMaterial.tres")

const time_to_disappear_in_dark: float = 2

@export var item: Inventory.ItemType
@export var pickup_description: String
@export var require_interact_to_pickup: bool = true

@export_category("Internal")
@export var tooltip: Label
@export var sprite: Sprite2D


var _time_left_to_disappear: float = 0
var _in_light = false

var _is_nearby: bool = false

func _ready():
	tooltip.hide()
	LightArea2DManager.light_area_entered.connect(_on_light_area_entered)
	LightArea2DManager.light_area_exited.connect(_on_light_area_exited)
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_light_area_entered(node, light_area):
	if node != self: return
	
	_in_light = true
	modulate.a = 1

func _on_light_area_exited(node):
	if node != self: return
	
	_in_light = false
	_time_left_to_disappear = time_to_disappear_in_dark

func _on_body_entered(body):
	sprite.material = OUTLINE_MATERIAL
	tooltip.show()
	_is_nearby = true

func _on_body_exited(body):
	sprite.material = null
	tooltip.hide()
	_is_nearby = false

func _process(delta: float) -> void:
	if !_in_light:
		_time_left_to_disappear -= delta
		_time_left_to_disappear = max(0, _time_left_to_disappear)
		modulate.a = _time_left_to_disappear / time_to_disappear_in_dark
		if _time_left_to_disappear == 0:
			modulate.a = 0
	
	if !_is_nearby: return
	if require_interact_to_pickup:
		if Input.is_action_just_pressed("interact"):
			pickup()
	else:
		pickup()

func pickup():
	Inventory.add_item(item, pickup_description)
	
	queue_free()
