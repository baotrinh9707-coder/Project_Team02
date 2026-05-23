extends Node2D

# ============================================
# UI REFERENCES
# ============================================
@onready var button_play_sfx = $CanvasLayer/Control/ScrollContainer/VBoxContainer/Button_PlaySFX
@onready var slider_sfx_volume = $CanvasLayer/Control/ScrollContainer/VBoxContainer/HSlider_SFXVolume
@onready var checkbox_mute_sfx = $CanvasLayer/Control/ScrollContainer/VBoxContainer/CheckBox_MuteSFX

@onready var button_play_music = $CanvasLayer/Control/ScrollContainer/VBoxContainer/Button_PlayMusic
@onready var button_stop_music = $CanvasLayer/Control/ScrollContainer/VBoxContainer/Button_StopMusic
@onready var slider_music_volume = $CanvasLayer/Control/ScrollContainer/VBoxContainer/HSlider_MusicVolume

# Effects
@onready var option_button_effect = $CanvasLayer/Control/ScrollContainer/VBoxContainer/OptionButton_Effect

# Example: Click SFX (complete)
@onready var audio_click = $AudioStreamPlayer_Click

# TODO: Need to add other SFX players:
# - audio_jump = $AudioStreamPlayer_Jump
# - audio_coin = $AudioStreamPlayer_Coin

# SFX array to random play
var current_music_id: String = ""
var current_music_volume_db: float = 0.0
var music_player: AudioStreamPlayer
var sfx_players: Array[AudioStreamPlayer] = []
var current_sfx_bus_name: String = "SFX"
var sfx_bus_index: int = -1
# TODO: Add reference for AudioStreamPlayer_Music
# @onready var audio_music = $AudioStreamPlayer_Music


func _ready() -> void:
	_setup_sfx()
	_setup_ui_connections()
	_setup_effects()

func _setup_sfx() -> void:
	"""Initialize SFX players and initial configuration"""
	# TODO: Need to add other SFX players to array
	# Example: sfx_players = [audio_click, audio_jump, audio_coin]
	# Currently only has click (example)
	sfx_players = [audio_click]
	# Get SFX bus index
	sfx_bus_index = AudioServer.get_bus_index("SFX")
	# Set initial volume for all SFX
	_apply_sfx_volume(slider_sfx_volume.value)


func _on_play_sfx_pressed() -> void:
	"""Play random SFX from the list"""
	# Select random player
	var random_player = sfx_players[randi() % sfx_players.size()]
	# Play audio
	random_player.play()
	# Debug log
	print("Playing SFX: ", random_player.name)


func _apply_sfx_volume(value: float) -> void:
	"""Apply volume to SFX bus"""
	AudioServer.set_bus_volume_linear(sfx_bus_index, value)
	print("SFX volume: ", value)


func _on_sfx_volume_changed(value: float) -> void:
	"""Callback when SFX volume slider changes"""
	_apply_sfx_volume(value)


func _on_mute_sfx_toggled(button_pressed: bool) -> void:
	"""Callback when Mute SFX checkbox is toggled"""
	var volume:float = 0 if button_pressed else slider_sfx_volume.value
	
	AudioServer.set_bus_volume_linear(sfx_bus_index, volume)

	print("SFX muted: ", button_pressed)


func _setup_music() -> void:
	"""Initialize Music player and initial configuration"""
	# TODO: Need to implement
	# - Set initial volume for music player
	# - Refer to _setup_sfx() for reference
	pass


func _on_play_music_pressed() -> void:
	"""Play background music"""
	# TODO: Need to implement
	# - Check if music player is playing
	# - If not playing, call play()
	# - Refer to _on_play_sfx_pressed() for reference
	pass


func _on_stop_music_pressed() -> void:
	"""Stop background music"""
	# TODO: Need to implement
	# - Check if music player is playing
	# - If playing, call stop()
	pass


func _apply_music_volume(_value: float) -> void:
	"""Apply volume to music player"""
	# TODO: Need to implement
	# - Update bus volume for music bus
	# - Refer to _apply_sfx_volume() for reference
	pass


func _on_music_volume_changed(_value: float) -> void:
	"""Callback when slider Music volume changes"""
	# TODO: Need to implement
	# - Call _apply_music_volume(_value)
	pass


# ============================================
# UI SETUP
# ============================================

func _setup_ui_connections() -> void:
	"""Connect signals from UI controls"""
	# SFX connections
	button_play_sfx.pressed.connect(_on_play_sfx_pressed)
	slider_sfx_volume.value_changed.connect(_on_sfx_volume_changed)
	checkbox_mute_sfx.toggled.connect(_on_mute_sfx_toggled)
	
	# Music connections
	button_play_music.pressed.connect(_on_play_music_pressed)
	button_stop_music.pressed.connect(_on_stop_music_pressed)
	slider_music_volume.value_changed.connect(_on_music_volume_changed)
	
	# Effects
	option_button_effect.item_selected.connect(_on_effect_selected)



func _setup_effects() -> void:
	"""Setup effects option button"""
	option_button_effect.add_item("None")
	option_button_effect.add_item("Low Pass")
	option_button_effect.add_item("Pitch Shift")
	option_button_effect.add_item("Reverb")


func _on_effect_selected(index: int) -> void:
	
	while AudioServer.get_bus_effect_count(sfx_bus_index) > 0:
		AudioServer.remove_bus_effect(sfx_bus_index, 0)
		
	match index:
		1:
			var lowpass = AudioEffectLowPassFilter.new()
			lowpass.cutoff_hz = 1000
			AudioServer.add_bus_effect(sfx_bus_index, lowpass)
		2:
			var pitch = AudioEffectPitchShift.new()
			pitch.pitch_scale = 1.1
			AudioServer.add_bus_effect(sfx_bus_index, pitch)
		3:
			#TODO: Add reverb effect
			pass
func play_sound(clip_id: String) -> void:
	print("[AudioManager] play_sound called with ID: ", clip_id)

	var database: AudioDatabase = load("res://assets/audio/audio_database.tres")

	if database == null:
		print("[AudioManager] Audio database not found")
		return

	print("[AudioManager] Audio database loaded")

	var clip = _find_audio_clip(database, clip_id)

	if clip == null:
		print("[AudioManager] Audio clip not found with ID: ", clip_id)
		return

	print("[AudioManager] Audio clip found: ", clip.id)
	print("[AudioManager] Clip stream: ", clip.stream)
	print("[AudioManager] Clip bus: ", clip.bus)
	print("[AudioManager] Current SFX bus: ", current_sfx_bus_name)

	var player := AudioStreamPlayer.new()
	add_child(player)

	player.stream = clip.stream

	var bus_to_use: String = clip.bus

	if bus_to_use == "SFX":
		bus_to_use = current_sfx_bus_name

	player.bus = bus_to_use
	player.volume_db = clip.volume_db

	if clip.randomize_pitch:
		player.pitch_scale = randf_range(clip.pitch_min, clip.pitch_max)

	print("[AudioManager] Final bus used: ", player.bus)
	print("[AudioManager] Volume dB: ", player.volume_db)
	print("[AudioManager] Pitch scale: ", player.pitch_scale)

	player.play()
	print("[AudioManager] Sound is playing: ", clip_id)

	player.finished.connect(player.queue_free)

func _find_audio_clip(database: AudioDatabase, clip_id: String) -> AudioClip:
	for clip in database.clips:
		if clip != null and clip.id == clip_id:
			return clip

	return null
func get_current_sfx_bus_name() -> String:
	print("[AudioManager] Current SFX bus name: ", current_sfx_bus_name)
	return current_sfx_bus_name


func switch_sfx_bus(bus_name: String) -> void:
	print("[AudioManager] Request switch SFX bus to: ", bus_name)

	if bus_name == "":
		print("[AudioManager] Bus name is empty")
		return

	var bus_index := AudioServer.get_bus_index(bus_name)

	if bus_index == -1:
		print("[AudioManager] Bus not found: ", bus_name)
		return

	var old_bus_name := current_sfx_bus_name
	current_sfx_bus_name = bus_name

	print("[AudioManager] Switching SFX bus from ", old_bus_name, " to ", current_sfx_bus_name)

	for player in sfx_players:
		if player == null:
			print("[AudioManager] Found null SFX player, skipped")
			continue

		print("[AudioManager] Player ", player.name, " bus: ", player.bus, " -> ", bus_name)
		player.bus = bus_name

	print_audio_debug_info()


func print_audio_debug_info() -> void:
	print("========== AUDIO DEBUG ==========")
	print("Current SFX Bus Name: ", current_sfx_bus_name)
	print("SFX Bus Index: ", sfx_bus_index)
	print("SFX Players Count: ", sfx_players.size())

	for player in sfx_players:
		if player != null:
			print("SFX Player: ", player.name, " | Bus: ", player.bus)
		else:
			print("SFX Player: null")

	print("Audio Bus List:")

	for i in range(AudioServer.get_bus_count()):
		print(
			"Bus Index: ", i,
			" | Name: ", AudioServer.get_bus_name(i),
			" | Send: ", AudioServer.get_bus_send(i),
			" | Volume dB: ", AudioServer.get_bus_volume_db(i),
			" | Effects: ", AudioServer.get_bus_effect_count(i)
		)

	print("=================================")
var music_tween: Tween


func play_music(music_id: String, volume_db: float = 0.0, fade_in: float = 0.0, fade_out: float = 0.0) -> void:
	print("[AudioManager] play_music called: ", music_id)

	if current_music_id == music_id and music_player != null and music_player.playing:
		print("[AudioManager] Music already playing: ", music_id)
		return

	var database: AudioDatabase = load("res://assets/audio/audio_database.tres")

	if database == null:
		print("[AudioManager] Audio database not found")
		return

	var clip = _find_audio_clip(database, music_id)

	if clip == null:
		print("[AudioManager] Music clip not found: ", music_id)
		return

	if music_player == null:
		music_player = AudioStreamPlayer.new()
		add_child(music_player)

	if music_tween != null:
		music_tween.kill()

	if music_player.playing and fade_out > 0.0:
		print("[AudioManager] Fade out old music")
		music_tween = create_tween()
		music_tween.tween_property(music_player, "volume_db", -40.0, fade_out)
		await music_tween.finished

	current_music_id = music_id
	current_music_volume_db = volume_db

	music_player.stream = clip.stream
	music_player.bus = clip.bus

	if fade_in > 0.0:
		music_player.volume_db = -40.0
	else:
		music_player.volume_db = volume_db

	music_player.play()

	if fade_in > 0.0:
		print("[AudioManager] Fade in new music")
		music_tween = create_tween()
		music_tween.tween_property(music_player, "volume_db", volume_db, fade_in)

	print("[AudioManager] Music started: ", music_id)
func get_current_music_id() -> String:
	print("[AudioManager] get_current_music_id: ", current_music_id)
	return current_music_id


func get_current_music_volume_db() -> float:
	print("[AudioManager] get_current_music_volume_db: ", current_music_volume_db)
	return current_music_volume_db
