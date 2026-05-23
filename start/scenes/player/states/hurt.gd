extends PlayerState

func _enter():
	obj.change_animation("hurt")
	obj.velocity.y = -250
	obj.velocity.x = -250 * sign(obj.velocity.x)
	timer = 0.5

func _exit():
	pass

func _update( delta: float):
	if update_timer(delta):
		if(obj.health <= 0) :
			change_state(fsm.states.dead)
		else:
			change_state(fsm.states.idle)
