extends FSMState

# --- 1. CÁC BIẾN EXPORT (Có thể chỉnh ngoài Inspector) ---
@export var animated_sprite_2d: AnimatedSprite2D # Node hình ảnh nhân vật
@export var dash_speed: float = 450.0 # Tốc độ lướt
@export var dash_duration: float = 0.2 # Thời gian lướt (nên ngắn thôi)

# 🟢 [MỚI] Các biến cho hiệu ứng Bóng mờ
@export var ghost_lifetime: float = 0.3 # Thời gian mỗi bóng mờ tồn tại (giây)
@export var ghost_frequency: float = 0.04 # Thời gian giữa 2 lần tạo bóng mờ (nên < 0.1)
@export var ghost_color: Color = Color(0.6, 0.6, 1.0, 0.6) # Màu sắc/độ trong của bóng mờ (xanh nhạt)

# --- Các biến cho hiệu ứng Khói ---
@export var smoke_spawn_offset: Vector2 = Vector2(0, 0) # Vị trí khói
@export var smoke_effect_scene: PackedScene # Scene khói

# --- 2. CÁC BIẾN NỘI BỘ ---
var dash_direction: Vector2 = Vector2.ZERO # Hướng lướt
var dash_timer: float = 0.0 # Bộ đếm thời gian lướt
var trail_timer: float = 0.0 # Bộ đếm thời gian tạo khói tàn dư
var is_setup: bool = false # Cờ thiết lập

# 🟢 [MỚI] Bộ đếm thời gian tạo bóng mờ
var ghost_timer: float = 0.0 

# --- 3. HÀM CHÍNH ---

func _setup_dash() -> void:
	is_setup = true
	dash_timer = dash_duration
	trail_timer = 0.0
	ghost_timer = 0.0
	
	animated_sprite_2d.play("fox_walk")
	
	# Xác định hướng lướt
	var move_dir = obj.get_move_axis()
	if move_dir != 0:
		dash_direction = Vector2(move_dir, 0).normalized()
	else:
		dash_direction = Vector2(-1 if animated_sprite_2d.flip_h else 1, 0)
	
	# Tạo khói ban đầu
	spawn_smoke("dash_smoke")
	
	# 🟢 [MỚI] Tạo bóng mờ đầu tiên ngay lập tức
	spawn_ghost()

# Xử lý vật lý mỗi khung hình
func _on_physics_process(delta: float) -> void:
	if not is_setup:
		_setup_dash()
		
	# Giảm các bộ đếm
	dash_timer -= delta
	trail_timer += delta
	ghost_timer += delta # 🟢 [MỚI] Tăng bộ đếm bóng mờ

	# --- Logic di chuyển ---
	obj.velocity.x = dash_direction.x * dash_speed
	obj.velocity.y = 0
	obj.move_and_slide()
	
	# --- Logic Khói tàn dư ---
	if trail_timer >= 0.05:
		trail_timer = 0.0
		spawn_smoke("walk_smoke")
		
	# 🟢 [MỚI] Logic Tạo bóng mờ nhân vật
	if ghost_timer >= ghost_frequency:
		ghost_timer = 0.0
		spawn_ghost()

# Xử lý chuyển trạng thái
func _on_next_transitions() -> void:
	if dash_timer <= 0:
		is_setup = false # Reset cờ thiết lập để dùng cho lần sau
		if obj.is_on_floor():
			transition.emit("Idle")
		else:
			transition.emit("Fall")

# --- 4. HÀM PHỤ TẠO HIỆU ỨNG ---

# Hàm tạo Khói (giữ nguyên cũ của bạn)
func spawn_smoke(anim_name: String) -> void:
	if smoke_effect_scene == null: return
	var smoke = smoke_effect_scene.instantiate() as AnimatedSprite2D
	if smoke == null: return
	smoke.global_position = obj.global_position + smoke_spawn_offset
	smoke.flip_h = animated_sprite_2d.flip_h
	get_tree().current_scene.add_child(smoke)
	smoke.play(anim_name)

# 🟢 [MỚI] Hàm chính tạo Bóng mờ nhân vật
func spawn_ghost() -> void:
	if animated_sprite_2d == null: return

	# 1. Nhân bản Sprite hiện tại của nhân vật
	var ghost = animated_sprite_2d.duplicate() as AnimatedSprite2D
	get_tree().current_scene.add_child(ghost)

	# 2. Match visual của bóng mờ y hệt nhân vật tại thời điểm đó
	ghost.global_transform = animated_sprite_2d.global_transform
	ghost.flip_h = animated_sprite_2d.flip_h
	ghost.frame = animated_sprite_2d.frame
	ghost.animation = animated_sprite_2d.animation
	ghost.stop()

	# 3. Áp màu sắc và độ trong cài đặt từ Inspector
	ghost.modulate = ghost_color
	
	# 4. Tạo hiệu ứng mờ dần bằng Tween
	# (Dùng Tween đẹp hơn nhiều so với việc giảm opacity trong _process)
	var tween = ghost.create_tween()
	# Giảm độ mờ (modulate:a) về 0 trong thời gian ghost_lifetime
	tween.tween_property(ghost, "modulate:a", 0.0, ghost_lifetime).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	# Khi Tween chạy xong thì tự động xóa bóng mờ
	tween.tween_callback(ghost.queue_free)
