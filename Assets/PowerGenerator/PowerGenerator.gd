class_name PowerGenerator extends Node2D

@export var target_group: String = "Red Generator"
@export var call_method: String = "activate"
@export var call_deactivate_method: String = "deactivate"

func activate():
	for n in get_tree().get_nodes_in_group(target_group):
		if n is not Node2D: continue
		
		n.call(call_method)

func deactivate():
	for n in get_tree().get_nodes_in_group(target_group):
		if n is not Node2D: continue
		
		n.call(call_deactivate_method)
