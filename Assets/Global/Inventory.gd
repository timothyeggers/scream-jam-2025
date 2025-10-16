extends Node

enum ItemType { 
	GLOWSTICK,
	FUELCAN,
	YELLOW_KEY,
	BLUE_KEY,
	RED_KEY,
	BLACK_KEY,
	WHITE_KEY
}

var glow_sticks: int = 4
var fuel_cans: int = 1
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
	Game.log.push_next(description)

func has_yellow_key():
	return _has_yellow_key
