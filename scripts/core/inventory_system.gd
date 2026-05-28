extends Node
class_name InventorySystemd

signal coin_changed(new_amount: int)
signal item_collected(item_type: String, amount: int)

var coins: int = 0
var keys: int = 0

# --- THÊM 2 BIẾN NÀY ĐỂ NHẬN FILE ÂM THANH TỪ EDITOR ---
@export var coin_sfx: AudioStream
@export var key_sfx: AudioStream

func _ready() -> void:
	pass

func add_coin(amount: int) -> void:
	if amount <= 0:
		return

	coins += amount
	coin_changed.emit(coins)
	item_collected.emit("coin", amount)
	print("Collected ", amount, " coins. Total: ", coins)
	
	# --- GỌI ÂM THANH KHI NHẶT XU ---
	if coin_sfx:
		play_sound_by_code(coin_sfx)

func add_key(amount: int = 1) -> void:
	if amount <= 0:
		return

	keys += amount
	item_collected.emit("key", amount)
	print("Collected ", amount, " key. Total keys: ", keys)
	
	# --- GỌI ÂM THANH KHI NHẶT CHÌA KHÓA ---
	if key_sfx:
		play_sound_by_code(key_sfx)

func use_key() -> bool:
	if keys <= 0:
		print("No key available")
		return false

	keys -= 1
	item_collected.emit("key", -1)
	print("Used 1 key. Remaining keys: ", keys)
	return true

func has_key() -> bool:
	return keys > 0

func get_gold() -> int:
	return coins

func get_keys() -> int:
	return keys

# --- HÀM EXTRA: TẠO VÀ PHÁT AUDIO BẰNG CODE ---
func play_sound_by_code(stream: AudioStream) -> void:
	var audio_player = AudioStreamPlayer.new()
	audio_player.stream = stream
	
	# Đảm bảo bạn đã tạo bus "SFX" trong tab Audio dưới đáy màn hình Godot
	audio_player.bus = "SFX" 
	
	add_child(audio_player)
	
	# Xóa node khỏi Scene Tree sau khi phát xong để chống rò rỉ bộ nhớ
	audio_player.finished.connect(audio_player.queue_free)
	
	audio_player.play()
