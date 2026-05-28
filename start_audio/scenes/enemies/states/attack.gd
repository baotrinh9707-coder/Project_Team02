extends EnemyState

@export var attack_duration = 0.4
@export var active_duration = 0.2

var active_timer = 0.0

func _enter() -> void:
	obj.change_animation("attack")
	timer = attack_duration
	obj.velocity.x = 0
	active_timer = active_duration


func _exit() -> void:
	obj.get_node("Direction/HitArea2D/CollisionShape2D").disabled = true


func _update(delta: float) -> void:
	# active duration
	if active_timer > 0:
		active_timer -= delta
		if active_timer <= 0:
			obj.get_node("Direction/HitArea2D/CollisionShape2D").disabled = false
			active_timer = 0

	if update_timer(delta):
		change_state(fsm.previous_state)
