extends EnemyState

func _enter() -> void:
	obj.change_animation("run")
	obj.enable_check_player_in_sight()

func _exit() -> void:
	obj.disable_check_player_in_sight()

func _update(_delta):
	obj.velocity.x = obj.direction * obj.movement_speed
	if _should_turn_around():
		if obj.is_left():
			obj.turn_right()
		else:
			obj.turn_left()

# check should turn around
func _should_turn_around() -> bool:
	if obj.is_touch_wall():
		return true
	if obj.is_on_floor() and obj.is_can_fall():
		return true
	return false
