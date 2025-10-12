class_name LightArea2D extends Area2D

@export var is_harmful: bool = true

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body is Entity:
		body.light_area_entered.emit(self)

func _on_body_exited(body):
	if body is Entity:
		body.light_area_exited.emit(self)
