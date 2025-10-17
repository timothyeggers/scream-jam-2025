class_name PowerGenerator extends Node2D

const OUTLINE_MATERIAL = preload("res://Assets/OutlineMaterial.tres")
const GENERATOR_ON_SPRITE = preload("res://Assets/generator_on.png")
const GENERATOR_OFF_SPRITE = preload("res://Assets/generator_off.png")

@export var target_group: String = "Red Generator"
@export var call_method: String = "activate"
@export var call_deactivate_method: String = "deactivate"
@export var time_active_on_fuel: float = 15

@export_category("Internal")
@export var area: Area2D
@export var tooltip: Label
@export var sprite: Sprite2D
@export var fuel_gauge: AutohideProgressBar

var _is_nearby: bool = false
var _is_active: bool = false
var _fuel_left: float = 0

func _ready():
	tooltip.hide()
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body is not Player: return
	sprite.material = OUTLINE_MATERIAL
	tooltip.show()
	_is_nearby = true

func _on_body_exited(body):
	if body is not Player: return
	sprite.material = null
	tooltip.hide()
	_is_nearby = false

func _process(delta: float) -> void:
	fuel_gauge.value = (_fuel_left / time_active_on_fuel) * 100
	_fuel_left -= delta
	if _is_active && _fuel_left <= 0:
		deactivate()
	
	if !_is_nearby: return
	
	if Input.is_action_just_pressed("interact"):
		if Inventory.fuel_cans > 0:
			Inventory.fuel_cans -= 1
			_is_active = true
			if _is_active:
				activate()
		else:
			Game.ui.log_message("You have no fuel!")


func activate():
	for n in get_tree().get_nodes_in_group(target_group):
		if n is not Node2D: continue
		
		n.call(call_method)
	sprite.texture = GENERATOR_ON_SPRITE
	_fuel_left = time_active_on_fuel
	fuel_gauge.set_value_bar(99)
	tooltip.hide()

func deactivate():
	for n in get_tree().get_nodes_in_group(target_group):
		if n is not Node2D: continue
		
		n.call(call_deactivate_method)
	sprite.texture = GENERATOR_OFF_SPRITE
	fuel_gauge.hide()
	if _is_nearby:
		tooltip.show()
