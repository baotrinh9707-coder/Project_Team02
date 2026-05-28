extends FSMState

@export var player: Player
@export var animated_sprite_2d: AnimatedSprite2D


func _on_enter() -> void:
	if not player.is_wall_jumping:
		player.perform_jump()

	if animated_sprite_2d.animation != "fox_jump":
		animated_sprite_2d.play("fox_jump")
	
	AudioManager.play_sound("player_jump")


func _on_physics_process(delta: float) -> void:
	var direction := player.get_move_axis()

	if direction < 0:
		player.player_direction = Vector2.LEFT
	elif direction > 0:
		player.player_direction = Vector2.RIGHT

	if not player.is_wall_jumping:
		player.velocity.x = move_toward(player.velocity.x, direction * player.air_speed, player.acceleration * delta)

	if Input.is_action_just_released("jump") and player.velocity.y < 0:
		player.velocity.y *= 0.5

	player.velocity.y += player.gravity * delta
	player.move_and_slide()
	player.update_wall_normal()
	player.update_wall_jump_timer(delta)

func _on_next_transitions() -> void:
	if Input.is_action_just_pressed("dash"):
		transition.emit("Dash")
		return

	if player.should_wall_cling():
		transition.emit("WallCling")
		return

	if Input.is_action_just_pressed("jump") and player.can_jump():
		player.perform_jump()

		if animated_sprite_2d.animation != "fox_jump":
			animated_sprite_2d.play("fox_jump")

		return

	if player.velocity.y > 0:
		transition.emit("Fall")
