extends Area2D
class_name AmbienceArea2D

@export var ambience_music_id: String = "boss_fight"
@export var volume_db: float = 0.0
@export var fade_in: float = 1.0

var previous_music_id: String = ""
var previous_volume_db: float = 0.0
var is_player_inside: bool = false


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

	# Nếu Player nằm ở Layer 2 thì để mask = 2
	collision_mask = 2

	print("[AmbienceArea2D] Ready")
	print("[AmbienceArea2D] Ambience music ID: ", ambience_music_id)


func _on_body_entered(body: Node2D) -> void:
	if is_player_inside:
		return

	if not body.is_in_group("player"):
		return

	is_player_inside = true
	previous_music_id = AudioManager.get_current_music_id()
	previous_volume_db = AudioManager.get_current_music_volume_db()

	print("[AmbienceArea2D] Player entered")
	print("[AmbienceArea2D] Previous music: ", previous_music_id)
	print("[AmbienceArea2D] Switch to ambience music: ", ambience_music_id)

	AudioManager.play_music(ambience_music_id, volume_db, fade_in)


func _on_body_exited(body: Node2D) -> void:
	if not is_player_inside:
		return

	if not body.is_in_group("player"):
		return

	is_player_inside = false

	print("[AmbienceArea2D] Player exited")
	print("[AmbienceArea2D] Restore music: ", previous_music_id)

	if previous_music_id != "":
		AudioManager.play_music(previous_music_id, previous_volume_db, fade_in)
