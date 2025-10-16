class_name LightArea2D extends Area2D

@export var is_harmful: bool = true
## If this LightArea2D needs a raycast to hit bodies entering it's area.
@export var line_of_sight: bool = false
@export var line_of_sight_origin: Node2D


func _enter_tree() -> void:
	LightArea2DManager.add(self)

func _exit_tree():
	LightArea2DManager.remove(self)

## If there's no collision to pos, returns true.  Otherwise returns false.
func get_line_of_sight(global_pos: Vector2) -> bool:
	if !line_of_sight: return true
	var origin = global_position if !line_of_sight_origin else line_of_sight_origin.global_position
	var space_state = get_world_2d().direct_space_state
	# use global coordinates, not local to node
	var query = PhysicsRayQueryParameters2D.create(origin, global_pos, 1 << 7)
	var result = space_state.intersect_ray(query)
	
	if result.size() > 0: return false
	else: return true

#body_entered.connect(_on_body_entered)
#body_exited.connect(_on_body_exited)
#area_entered.connect(_on_area_entered)
#area_exited.connect(_on_area_exited)

#func _process(delta: float) -> void:
	#for area in get_overlapping_areas():
		#if !area.get_parent().is_in_group("Vanishing"): continue
		#area.get_parent().emit_signal("light_area_entered", self)
	#for body in get_overlapping_bodies():
		#if !body.get_parent().is_in_group("Vanishing"): continue
		#body.get_parent().emit_signal("light_area_exited", self)

#func _on_area_entered(area):
	#if area.get_parent() is ItemPickup:
		#area.get_parent().light_area_entered.emit(self)
#
#func _on_area_exited(area):
	#if area.get_parent() is ItemPickup:
		#area.get_parent().light_area_exited.emit(self)
#
#func _on_body_entered(body):
	#if body is Entity:
		#body.light_area_entered.emit(self)
#
#func _on_body_exited(body):
	#if body is Entity:
		#body.light_area_exited.emit(self)
