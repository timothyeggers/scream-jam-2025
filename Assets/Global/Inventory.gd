extends Node

var glow_sticks: int = 4

var items: Array[Node2D]

func add_item(item: Node2D, description: String):
	if item is GlowStick:
		glow_sticks += 2
		Game.log.push_next(description)
	else:
		items.append(item)
