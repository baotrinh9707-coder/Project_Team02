class_name PlayerFSM
extends Node

@export var initial_node_state: FSMState
var states: Dictionary = {}
var current_state: FSMState = null
var obj: Node = null

func _ready() -> void:
	obj = get_parent()
	for child in get_children():
		if child is FSMState:
			states[child.name.to_lower()] = child
			child.fsm = self
			child.obj = obj
			child.transition.connect(transition_to)
			
	if initial_node_state == null and states.size() > 0:
		initial_node_state = states.values()[0]
		
	current_state = initial_node_state
	if current_state:
		current_state._on_enter()

func _physics_process(delta: float) -> void:
	if current_state:
		current_state._on_physics_process(delta)
		current_state._on_next_transitions()

func transition_to(state_name: String) -> void:
	var new_state: FSMState = states.get(state_name.to_lower())
	if new_state == null or current_state == new_state: return
	if current_state: current_state._on_exit()
	current_state = new_state
	current_state._on_enter()
