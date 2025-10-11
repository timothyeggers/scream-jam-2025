class_name StateMachine extends Node

@export var default_state: State

var current_state: State
var states: Dictionary = {}

func _ready():
	if default_state:
		current_state = default_state
		current_state.enter()
	
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.transitioned.connect(_on_child_transition)
			child.force_transitioned.connect(transition)

func _process(delta):
	if current_state:
		current_state.process(delta)

func _physics_process(delta):
	if current_state:
		current_state.physics_process(delta)

func _on_child_transition(state, new_state):
	if state != current_state:
		return
	
	var new = states.get(new_state.to_lower())
	if !new:
		return
	
	if current_state:
		current_state.exit()
	
	new.enter()
	current_state = new

func transition(new_state):
	var new = states.get(new_state.to_lower())
	if !new:
		return
	
	if current_state:
		current_state.exit()
	
	new.enter()
	current_state = new
