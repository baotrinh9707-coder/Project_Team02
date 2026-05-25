extends InteractiveArea2D

# Biến này cho phép bạn chỉnh số lượng tiền cho từng cục ở ngoài bảng Inspector
@export var coin_amount: int = 1

func _ready() -> void:
	# Kết nối tín hiệu chạm
	interaction_available.connect(_on_interaction_available)
	super._ready()

func collect_key():
	# Gọi hệ thống túi đồ và cộng tiền
	GameManager.inventory_system.add_key(coin_amount)
	# Tự hủy hình ảnh đồng xu
	queue_free()

func _on_interaction_available() -> void:
	collect_key()
