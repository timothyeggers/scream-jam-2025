extends Node

signal light_area_entered(node, light_area)
signal light_area_exited(node)

const LIGHT_AREA2D_AFFECTED_GROUP = "Vanishing"

var light_areas: Array[LightArea2D] = []
var _in_areas: Array[Node2D] = []

func _process(delta: float) -> void:
	var was_in_areas = _in_areas.duplicate()
	var newly_in_area: Array[Node2D] = []
	for light_area in light_areas:
		if !light_area.monitoring: continue
		for area in light_area.get_overlapping_areas():
			if !area.is_in_group(LIGHT_AREA2D_AFFECTED_GROUP): continue
			light_area_entered.emit(area, light_area)
			if !newly_in_area.has(area):
				newly_in_area.append(area)
	for light_area in light_areas:
		if !light_area.monitoring: continue
		for body in light_area.get_overlapping_bodies():
			if !body.is_in_group(LIGHT_AREA2D_AFFECTED_GROUP): continue
			if light_area.get_line_of_sight(body.global_position):
				light_area_entered.emit(body, light_area)
				if !newly_in_area.has(body):
					newly_in_area.append(body)
	
	var exited_area = newly_in_area.filter(func(element): return was_in_areas.has(element))
	for node in exited_area:
		light_area_exited.emit(node)
	
	_in_areas = newly_in_area

func find_differences(array1: Array, array2: Array) -> Dictionary:
	var unique_to_array1 = array1.filter(func(element): return not array2.has(element))
	var unique_to_array2 = array2.filter(func(element): return not array1.has(element))
	return {"unique_to_array1": unique_to_array1, "unique_to_array2": unique_to_array2}

	#for body in get_overlapping_bodies():
		#if !body.get_parent().is_in_group("Vanishing"): continue
		#body.get_parent().emit_signal("light_area_exited", self)

func add(light_area: LightArea2D):
	light_area.monitorable = true
	light_area.monitoring = true
	light_areas.append(light_area)

func remove(light_area: LightArea2D):
	light_area.monitorable = false
	light_area.monitoring = false
	
