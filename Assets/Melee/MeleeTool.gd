class_name MeleeTool extends HandTool

@export var hitbox_anchor: Node2D

func activate():
	super()
	
	var hitbox = HitBox.create(self)
	hitbox.global_position = hitbox_anchor.global_position
	hitbox.global_rotation = hitbox_anchor.global_rotation
