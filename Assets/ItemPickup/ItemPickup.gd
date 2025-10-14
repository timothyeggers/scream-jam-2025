extends Node2D

const OUTLINE_MATERIAL = preload("res://Assets/OutlineMaterial.tres")

@export var item: PackedScene
@export var thumbnail: Texture2D
@export var pickup_description: String

@export_category("Internal")
@export var area: Area2D
@export var tooltip: Label
@export var sprite: Sprite2D

var _is_nearby: bool = false

func _ready():
	if thumbnail:
		sprite.texture = thumbnail
	
	tooltip.hide()
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	sprite.material = OUTLINE_MATERIAL
	tooltip.show()
	_is_nearby = true

func _on_body_exited(body):
	sprite.material = null
	tooltip.hide()
	_is_nearby = false

func _process(delta: float) -> void:
	if !_is_nearby: return
	if Input.is_action_just_pressed("interact"):
		pickup()

func pickup():
	if item:
		Inventory.add_item(item.instantiate(), pickup_description)
	
	queue_free()
