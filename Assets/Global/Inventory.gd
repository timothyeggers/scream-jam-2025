extends Node

signal item_consumed
signal item_obtained

enum ItemType { 
	GLOWSTICK,
	FUELCAN,
	YELLOW_KEY,
	BLUE_KEY,
	RED_KEY,
	BLACK_KEY,
	WHITE_KEY
}

var glow_sticks: int = 4:
	set(value):
		var old_value = fuel_cans
		glow_sticks = value
		if value < old_value:
			item_consumed.emit()
		elif value > old_value:
			item_obtained.emit()

var fuel_cans: int = 1:
	set(value):
		var old_value = fuel_cans
		fuel_cans = value
		if value < old_value:
			item_consumed.emit()
		elif value > old_value:
			item_obtained.emit()
		
var _has_yellow_key: bool = false

var items: Array[Node2D]

func add_item(item: ItemType, description: String):
	match item:
		ItemType.GLOWSTICK:
			glow_sticks += 2
		ItemType.FUELCAN:
			fuel_cans += 1
		ItemType.YELLOW_KEY:
			_has_yellow_key = true
	Game.ui.log_message(description)

func has_yellow_key():
	return _has_yellow_key
