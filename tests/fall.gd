extends FSMState

@export var player: Player
@export var animated_sprite_2d: AnimatedSprite2D

func _on_enter() -> void:
	animated_sprite_2d.play("fox_fall")

func _on_physics_process(delta: float) -> void:
	var direction := player.get_move_axis()

	if direction < 0:
		animated_sprite_2d.flip_h = true
		player.player_direction = Vector2.LEFT
	elif direction > 0:
		animated_sprite_2d.flip_h = false
		player.player_direction = Vector2.RIGHT

	player.velocity.x = direction * player.air_speed
	player.velocity.y += player.gravity * delta

	player.move_and_slide()

func _on_next_transitions() -> void:
	if Input.is_action_just_pressed("attack"):
		transition.emit("Attack")
		return

	if Input.is_action_just_pressed("jump") and player.can_jump():
		transition.emit("Jump")
		return

	if player.is_on_wall() and not player.is_on_floor() and player.velocity.y > 0:
		transition.emit("WallCling")
		return

	if player.is_on_floor():
		player.reset_jumps()

		if player.get_move_axis() != 0:
			transition.emit("Run")
		else:
			transition.emit("Idle")
