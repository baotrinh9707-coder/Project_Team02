extends InteractiveArea2D

func _ready():
	# Lắng nghe va chạm
	interaction_available.connect(_on_interaction_available)
	# Đừng quên gọi lớp cha nhé
	super()

func _on_interaction_available():
	# Gọi hàm từ player để tăng tốc độ gấp 3 lần trong 5 giây
	GameManager.player.speed_up(3, 5)
	
	# Ăn xong thì tự hủy cục power-up
	queue_free()
