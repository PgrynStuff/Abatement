class_name StateMachine
extends Node

@export var current_state : State

func _ready() -> void:
	for child in get_children():
		assert(child is State)
		child.transition.connect(state_transition)
	
	current_state.enter()

func state_transition(state_name: StringName) -> void:
	var state := find_child(state_name)
	
	assert(state)
	
	current_state.exit()
	current_state = state
	current_state.enter()

func _process(delta: float) -> void:
	current_state.update(delta)

func _physics_process(delta: float) -> void:
	current_state.physics_update(delta)
