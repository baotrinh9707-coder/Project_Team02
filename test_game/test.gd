extends Sprite2D

var label_node: Label
var start_x: float

# 1. Gọi khi node được khởi tạo trong bộ nhớ
func _init():
	print("Node được khởi tạo!")

# 2. Gọi khi node đã vào Scene Tree và sẵn sàng
func _ready():
	print("Node đã sẵn sàng trong Scene Tree!")
	
	# Thêm một Node con Label động
	label_node = Label.new()
	add_child(label_node)
	
	# Canh chỉnh vị trí Label cho nằm phía trên Sprite
	label_node.position = Vector2(-40, -80) 
	
	# Lưu lại tọa độ x ban đầu để tính quãng đường di chuyển
	start_x = position.x

	# --- ĐOẠN ĐỔI MÀU ĐƯỢC ĐƯA VÀO ĐÂY ---
	# Đợi đúng 2 giây sau khi node ready
	await get_tree().create_timer(2).timeout
	# Đổi màu Sprite sang màu đỏ
	self_modulate = Color.RED

# 3. Gọi mỗi khung hình
func _process(delta):
	# Tăng tọa độ x theo vận tốc 100 pixel/giây
	position.x += 100 * delta
	
	# Cập nhật nội dung Label hiển thị tọa độ x
	label_node.text = "Tọa độ x: " + str(int(position.x))
	
	# Kiểm tra: Khi di chuyển được >= 300 pixel thì tự hủy
	if position.x - start_x >= 300:
		queue_free()

# 4. Gọi khi node bị xóa khỏi Scene Tree bằng queue_free()
func _exit_tree():
	print("Node bị xóa khỏi Scene Tree!")
