class_name EnemyIdleState
extends EnemyState

func _enter():
	obj.enable_check_player_in_sight()
	obj.change_animation("idle")
	obj.velocity.x = 0

func _exit():
	obj.disable_check_player_in_sight()
