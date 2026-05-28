extends InteractiveArea2D

func _ready():
	interaction_available.connect(_on_interaction_available)
	super()

func _on_interaction_available():
	# Gọi hàm báo cho player biết là đã nhặt được kiếm
	GameManager.player.collected_blade()
	
	# Ăn xong tự hủy
	queue_free()
