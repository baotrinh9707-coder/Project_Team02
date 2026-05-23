class_name BackgroundMusic
extends Node

@export var music_id: String = "stage_music"
@export var volume_db: float = 0.0
@export var fade_in: float = 0.0
@export var fade_out: float = 1.0

func _ready() -> void:
	if not AudioManager:
		push_error("AudioManager not found! Make sure it's in autoload.")
		return

	AudioManager.play_music(music_id, volume_db, fade_in, fade_out)
	print("Background music started: ", music_id)
