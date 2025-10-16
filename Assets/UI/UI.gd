class_name UI extends Control

@export var log: RichTextLabel
@export var inventory: VBoxContainer
@export var glow_stick_label: Label
@export var fuel_label: Label
@export var apple_label: Label

var _show_inventory_time: float = 3
var _hide_inventory_dt: float = 0

var _time_to_delete_next: float = 3
var _dt: float = 0

var _messages: Array[String] = []

func _ready():
	Inventory.item_obtained.connect(_update_ui)
	Inventory.item_consumed.connect(_update_ui)
	_update_ui()

func _process(delta: float) -> void:
	_hide_inventory_dt += delta
	if _hide_inventory_dt >= _show_inventory_time:
		inventory.hide()
	
	if _messages.size() == 0: return
	
	_dt += delta
	if _dt >= _time_to_delete_next:
		_messages.pop_back()
		_dt = 0
		_update_log()

func _update_ui():
	inventory.show()
	_hide_inventory_dt = 0
	glow_stick_label.text = str(Inventory.glow_sticks)
	fuel_label.text = str(Inventory.fuel_cans)
	apple_label.text = str(Inventory.apples)

func log_message(text: String):
	_messages.push_front(text)
	if _messages.size() == 1:
		_dt = 0
	_update_log()

func _update_log():
	log.clear()
	for m in _messages:
		log.append_text(m)
		log.newline()
