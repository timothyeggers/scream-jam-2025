class_name LightArea2D extends Area2D

@export var is_harmful: bool = true

func _enter_tree() -> void:
	LightArea2DManager.add(self)

func _exit_tree():
	LightArea2DManager.remove(self)
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
