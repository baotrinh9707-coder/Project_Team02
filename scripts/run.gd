extends FSMState

@export var player: Player
@export var animated_sprite_2d: AnimatedSprite2D

func _on_physics_process(delta: float) -> void:
	var direction := player.get_move_axis()

	animated_sprite_2d.play("fox_walk")

	if direction < 0:
		animated_sprite_2d.flip_h = true
		player.player_direction = Vector2.LEFT
	elif direction > 0:
		animated_sprite_2d.flip_h = false
		player.player_direction = Vector2.RIGHT

	player.velocity.x = move_toward(player.velocity.x, direction * player.move_speed, player.acceleration * delta)

	if player.is_on_floor():
		player.reset_jumps()
	else:
		player.velocity.y += player.gravity * delta

	player.move_and_slide()


func _on_next_transitions() -> void:
	if Input.is_action_just_pressed("dash"):
		transition.emit("Dash")
		return

	if Input.is_action_just_pressed("attack"):
		transition.emit("Attack")
		return

	if not player.is_on_floor():
		transition.emit("Fall")
		return

	if Input.is_action_just_pressed("jump") and player.can_jump():
		transition.emit("Jump")
		return

	if player.get_move_axis() == 0:
		transition.emit("Idle")
