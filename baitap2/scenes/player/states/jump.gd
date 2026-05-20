extends PlayerState

func _enter() -> void:
	#Change animation to jump
	obj.change_animation("jump")
	
	# Set lực nhảy (Giả sử trong base_character.gd bạn có biến jump_velocity)
	obj.velocity.y = obj.jump_velocity if "jump_velocity" in obj else -300

func _update(_delta: float):
	#Control moving
	control_moving()
	
	#If velocity.y is greater than 0 change to fall
	if obj.velocity.y > 0:
		change_state(fsm.states.fall)
