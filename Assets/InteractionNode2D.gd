class_name InteractionNode2D extends Node2D

const OUTLINE_MATERIAL = preload("res://Assets/OutlineMaterial.tres")

@export_category("Internal")
@export var sprite: Sprite2D
@export var interaction_area: Area2D

var _in_area: bool = false

func _ready() -> void:
	interaction_area.body_entered.connect(_on_body_entered)
	interaction_area.body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body is not Player: return
	_in_area = true
	sprite.material = OUTLINE_MATERIAL

func _on_body_exited(body):
	if body is not Player: return
	_in_area = false
	sprite.material = null

func activate() -> void:
	pass

func _process(delta):
	if _in_area:
		if Input.is_action_just_pressed("interact"):
			activate()
