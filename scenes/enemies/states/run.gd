extends EnemyState

func _enter() -> void:
	obj.change_animation("run")

func _update(delta: float) -> void:
	# CHỈ KHI ĐANG ĐỨNG TRÊN ĐẤT mới check vực và tường
	if obj.is_on_floor():
		if obj.is_touch_wall() or obj.is_can_fall():
			obj.turn_around()
			
	# Luôn luôn giữ vận tốc chạy ngang (dù trên trời hay dưới đất)
	obj.velocity.x = obj.direction * obj.movement_speed

func take_damage(damage: Variant) -> void:
	# Cua dùng obj.fsm.change_state thay vì transition.emit
	obj.fsm.change_state("Hurt")
