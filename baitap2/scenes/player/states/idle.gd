extends PlayerState

## Idle state for player character

func _enter() -> void:
	obj.change_animation("idle")

func _update(_delta: float) -> void:
	#Control jump
	if control_jump():
		return 
	#Control moving
	if control_moving():
		return
	#If not on floor change to fall
	if not obj.is_on_floor():
		change_state(fsm.states.fall)
