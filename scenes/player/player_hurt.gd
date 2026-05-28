extends FSMState

var animated_sprite_2d: AnimatedSprite2D
var hurt_timer: float = 0.0

func _on_enter() -> void:
	animated_sprite_2d = obj.get_node("Direction/animated_sprite2D")
	animated_sprite_2d.play("fox_hit")
	
	# Apply a hurt jump (knockback)
	obj.velocity.y = -200
	obj.velocity.x = -150 * sign(obj.player_direction.x)
	hurt_timer = 0.4

func _on_physics_process(delta: float) -> void:
	# Apply gravity while hurt
	if not obj.is_on_floor():
		obj.velocity.y += obj.gravity * delta
	obj.move_and_slide()

func _on_next_transitions() -> void:
	hurt_timer -= get_physics_process_delta_time()
	if hurt_timer <= 0:
		if not obj.is_on_floor():
			transition.emit("Fall")
		else:
			transition.emit("Idle")
