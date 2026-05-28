class_name FSM
extends RefCounted

var obj: Node
var states: Dictionary = {}
var current_state: Node = null

func _init(_obj: Node, _states_parent: Node, _initial_state: Node) -> void:
	self.obj = _obj
	for child in _states_parent.get_children():
		states[child.name.to_lower()] = child
		child.obj = self.obj
		child.fsm = self
		
	current_state = _initial_state
	if current_state and current_state.has_method("_enter"):
		current_state._enter()

func _update(delta: float) -> void:
	if current_state and current_state.has_method("_update"):
		current_state._update(delta)

func change_state(state_name: String) -> void:
	var new_state = states.get(state_name.to_lower())
	if new_state == null or new_state == current_state:
		return
		
	if current_state and current_state.has_method("_exit"):
		current_state._exit()
		
	current_state = new_state
	if current_state and current_state.has_method("_enter"):
		current_state._enter()
