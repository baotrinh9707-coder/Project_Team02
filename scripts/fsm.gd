class_name PlayerFSM
extends Node

@export var initial_node_state: PlayerState
@export var debug: bool = false

var states: Dictionary = {}

var current_state: PlayerState = null
var previous_state: PlayerState = null
var default_state: PlayerState = null
var obj: Node = null

var current_state_name: String = ""


func _ready() -> void:
	obj = get_parent()

	for child in get_children():
		if child is PlayerState:
			var state_name: String = child.name.to_lower()
			states[state_name] = child

			child.fsm = self
			child.obj = obj
			child.transition.connect(transition_to)

			if debug:
				print("Adding state: ", child.name)

	if initial_node_state == null:
		if states.has("idle"):
			initial_node_state = states["idle"]
			push_warning("FSM: initial_node_state is null, falling back to 'Idle' state.")
		elif states.size() > 0:
			initial_node_state = states.values()[0]
			push_warning("FSM: initial_node_state is null, falling back to first state: " + initial_node_state.name)
		else:
			push_warning("FSM has no initial_node_state and no valid PlayerState children")
			return

	default_state = initial_node_state
	current_state = initial_node_state
	current_state_name = current_state.name.to_lower()
	current_state._on_enter()


func _process(delta: float) -> void:
	if current_state:
		current_state._on_process(delta)


func _physics_process(delta: float) -> void:
	if current_state:
		current_state._on_physics_process(delta)
		current_state._on_next_transitions()

		if debug:
			print("Current State: ", current_state_name)


func transition_to(state_name: String) -> void:
	if current_state != null and state_name.to_lower() == current_state.name.to_lower():
		return

	var new_state: PlayerState = states.get(state_name.to_lower())

	if new_state == null:
		if debug:
			print("Warning: State not found: ", state_name)
		return

	if current_state:
		current_state._on_exit()

	previous_state = current_state
	current_state = new_state
	current_state_name = current_state.name.to_lower()

	current_state._on_enter()

	if debug:
		print("Changed to state: ", current_state_name)
