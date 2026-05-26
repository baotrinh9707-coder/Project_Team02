extends FSMState

@export var player: CharacterBody2D
@export var animated_sprite_2d: AnimatedSprite2D
var dead_timer: float = 0.0

func _on_enter() -> void:
	animated_sprite_2d.play("fox_defeat") # Sửa lại tên animation chết
	player.velocity.x = 0
	dead_timer = 2.0 # Chờ 2 giây

func _on_physics_process(delta: float) -> void:
	player.velocity.y += player.gravity * delta
	player.move_and_slide()

	dead_timer -= delta
	if dead_timer <= 0:
		get_tree().reload_current_scene() # Reset lại màn chơi
