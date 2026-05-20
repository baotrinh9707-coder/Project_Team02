extends PlayerState

func _enter() -> void:
	#Change animation to fall
	obj.change_animation("fall")

func _update(_delta: float) -> void:
	#Control moving
	var is_moving = control_moving()

	#If on floor change to idle if not moving and not jumping
	if obj.is_on_floor():
		if control_jump():
			return
		if not is_moving:
			change_state(fsm.states.idle)
