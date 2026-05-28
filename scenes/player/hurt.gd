extends EnemyState

var hurt_timer: float = 0.0

func _enter() -> void: # Lưu ý: hệ enemy dùng _enter thay vì _on_enter
	obj.change_animation("hurt") # Đổi tên thành "hurt" cho đúng ảnh con cua
	obj.velocity.y = -300 # Cua giật nảy lên
	hurt_timer = 0.5 

func _update(delta: float) -> void: # Lưu ý: hệ enemy dùng _update thay vì _on_physics_process
	# Cua vẫn rơi xuống theo trọng lực
	obj.velocity.y += obj.gravity * delta
	obj.velocity.x = 0 # Không cho di chuyển ngang
	obj.move_and_slide()
	
	hurt_timer -= delta
	if hurt_timer <= 0:
		obj.fsm.change_state("Run") # Hết đau thì quay lại đi tuần tra (Run)
