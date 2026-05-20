extends Node
class_name FSMState

signal transition(state_name: String)

var fsm = null
var obj: Node = null
var timer: float = 0.0

func _on_enter() -> void:
	pass

func _on_exit() -> void:
	pass

func _on_process(_delta: float) -> void:
	pass

func _on_physics_process(_delta: float) -> void:
	pass

func _on_next_transitions() -> void:
	pass

func update_timer(delta: float) -> bool:
	if timer <= 0:
		return false

	timer -= delta
	return timer <= 0
