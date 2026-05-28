extends Area2D
class_name AmbienceArea2D

@export var ambience_music_id: String = "boss_music" # Tên ID nhạc boss bạn vừa đặt
@export var volume_db: float = 0.0

# [PHẦN EXTRA]: Khai báo thời gian chuyển nhạc mượt mà (Fade)
@export var fade_time: float = 2.0 # Tốn 2 giây để nhạc cũ nhỏ dần và nhạc mới to lên

var previous_music_id: String = ""
var is_player_inside: bool = false

func _ready() -> void:
	if not AudioManager:
		push_error("Không tìm thấy AudioManager!")
		return
		
	# Ép Collision Mask về 2 (để chỉ quét va chạm với layer của Player, không bị quái giẫm nhầm)
	collision_mask = 2 
	
	# Nối dây tín hiệu
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(_body: Node2D) -> void:
	if is_player_inside:
		return
	is_player_inside = true
	
	# 1. Ghi nhớ bài nhạc nền đang phát ở ngoài
	previous_music_id = AudioManager.current_music_id
	print("Vào phòng Boss! Chuyển sang nhạc: ", ambience_music_id)
	
	# 2. Phát nhạc Boss + kích hoạt EXTRA Fade In/Out (truyền fade_time vào cuối)
	AudioManager.play_music(ambience_music_id, volume_db, fade_time)

func _on_body_exited(_body: Node2D) -> void:
	if not is_player_inside:
		return
	is_player_inside = false
	
	print("Thoát phòng Boss! Quay về nhạc: ", previous_music_id)
	
	# Trả lại bài nhạc cũ + kích hoạt EXTRA Fade In/Out
	if previous_music_id != "":
		AudioManager.play_music(previous_music_id, 0.0, fade_time)	
