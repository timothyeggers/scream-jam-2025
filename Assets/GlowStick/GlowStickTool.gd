class_name GlowStickTool extends HandTool

@export var throw_force: float = 155
@export var glow_stick: GlowStick
@export var spawn_origin: Node2D

func activate():
	super()
	var node = GlowStick.create(Game.get_world())
	node.global_position = spawn_origin.global_position
	node.apply_central_impulse(spawn_origin.global_position.direction_to(get_global_mouse_position()) * throw_force)
