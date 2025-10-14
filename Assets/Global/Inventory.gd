extends Node

enum ItemType { 
	GLOWSTICK,
	FUELCAN
}

var glow_sticks: int = 4
var fuel_cans: int = 1

var items: Array[Node2D]

func add_item(item: ItemType, description: String):
	match item:
		ItemType.GLOWSTICK:
			glow_sticks += 2
		ItemType.FUELCAN:
			fuel_cans += 1
	Game.log.push_next(description)
