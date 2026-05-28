extends EnemyState

# Chỉ cần xin cái ổ cắm cho cái càng cua thôi, mấy cái kia 'obj' tự lo được
@export var crab_hit_collision: CollisionShape2D 
var dead_timer: float = 0.0

func _enter() -> void:
	obj.change_animation("dead") # Gọi đúng animation của cua
	obj.velocity.x = 0
	dead_timer = 2.0 
	
	# Vô hiệu hóa cái càng, chết rồi không được kẹp người ta nữa!
	if crab_hit_collision:
		crab_hit_collision.set_deferred("disabled", true)

func _update(delta: float) -> void:
	# Xác cua vẫn rớt xuống đất
	obj.velocity.y += obj.gravity * delta
	obj.move_and_slide()
	
	dead_timer -= delta
	if dead_timer <= 0:
		obj.queue_free() # Chờ 2s rồi xóa xác con cua khỏi trần đời
