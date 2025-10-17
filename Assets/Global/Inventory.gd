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
	APPLE,
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

var apples: int = 0:
	set(value):
		var old_value = apples
		apples = value
		if value < old_value:
			item_consumed.emit()
		elif value > old_value:
			item_obtained.emit()

var _has_yellow_key: bool = false
var _has_blue_key: bool = false
var _has_red_key: bool = false
var _has_black_key: bool = false

var items: Array[Node2D]

func add_item(item: ItemType, description: String):
	match item:
		ItemType.GLOWSTICK:
			glow_sticks += 2
		ItemType.FUELCAN:
			fuel_cans += 1
		ItemType.YELLOW_KEY:
			_has_yellow_key = true
		ItemType.BLUE_KEY:
			_has_blue_key = true
		ItemType.RED_KEY:
			_has_red_key = true
		ItemType.BLACK_KEY:
			_has_black_key = true
		ItemType.APPLE:
			apples += 1
	Game.ui.log_message(description)

func has_yellow_key():
	return _has_yellow_key

func has_blue_key():
	return _has_blue_key

func has_red_key():
	return _has_red_key

func has_black_key():
	return _has_black_key

func has_three_apples():
	return apples >= 3
