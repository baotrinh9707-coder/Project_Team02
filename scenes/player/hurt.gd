extends FSMState

@export var player: CharacterBody2D
@export var animated_sprite_2d: AnimatedSprite2D
var hurt_timer: float = 0.0

func _on_enter() -> void:
	animated_sprite_2d.play("fox_hit") # Sửa lại tên animation cho đúng máy bạn
	player.velocity.y = -300 # Giật nảy người lên (số âm là bay lên)
	hurt_timer = 0.5 # Tồn tại trong 0.5 giây

func _on_physics_process(delta: float) -> void:
	# Vẫn bị ảnh hưởng bởi trọng lực để rớt xuống
	player.velocity.y += player.gravity * delta
	player.velocity.x = 0 # Không cho di chuyển ngang
	player.move_and_slide()

	hurt_timer -= delta
	if hurt_timer <= 0:
		transition.emit("Idle") # Hết 0.5s thì đứng im lại
