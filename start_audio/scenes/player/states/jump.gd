extends PlayerState

func _enter() -> void:
	#Change animation to jump
	obj.change_animation("jump")
	# play jump sound
	#AudioManager.play_sound("player_jump")
	pass

func _update(_delta: float):
	#Control moving
	control_moving()
	#If velocity.y is greater than 0 change to fall
	if obj.velocity.y > 0:
		change_state(fsm.states.fall)
	control_attack()
