extends FSMState

var animated_sprite_2d: AnimatedSprite2D
var dead_timer: float = 0.0

func _on_enter() -> void:
	animated_sprite_2d = obj.get_node("Direction/animated_sprite2D")
	animated_sprite_2d.play("fox_defeat")
	obj.velocity = Vector2.ZERO
	dead_timer = 1.5

func _on_physics_process(delta: float) -> void:
	# Still fall with gravity if in air
	if not obj.is_on_floor():
		obj.velocity.y += obj.gravity * delta
	else:
		obj.velocity.x = 0
	obj.move_and_slide()

func _on_next_transitions() -> void:
	dead_timer -= get_physics_process_delta_time()
	if dead_timer <= 0:
		# Reset health on respawn
		if "health" in obj and "max_health" in obj:
			obj.health = obj.max_health
		obj.respawn()
