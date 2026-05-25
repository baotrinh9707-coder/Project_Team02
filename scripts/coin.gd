extends InteractiveArea2D

func _ready() -> void:
	interaction_available.connect(_on_interaction_available)
	super._ready()
	
func collect_coin():
	# 1. Tăng tiền
	GameManager.inventory_system.add_coin(1)
	
	# 2. Tải scene hiệu ứng
	var effect_scene = preload("res://scene/collectibles/coin_effect.tscn")
	
	# 3. Tạo bản clone (thực thể)
	var effect_instance = effect_scene.instantiate()
	
	# 4. Đặt hiệu ứng nổ đúng vị trí cục vàng
	effect_instance.global_position = global_position
	
	# 5. Thêm hiệu ứng vào màn hình chơi hiện tại
	get_tree().current_scene.add_child(effect_instance)
	
	# 6. Cuối cùng mới xóa cục vàng đi
	queue_free()
	
func _on_interaction_available() -> void:
	collect_coin()
