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
@onready var audio_jump = $AudioStreamPlayer_Jump
@onready var audio_coin = $AudioStreamPlayer_Coin
@onready var audio_music = $AudioStreamPlayer_Music
# TODO: Need to add other SFX players:
# - audio_jump = $AudioStreamPlayer_Jump
# - audio_coin = $AudioStreamPlayer_Coin

# SFX array to random play
var sfx_players: Array[AudioStreamPlayer] = []

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
	sfx_players = [audio_click, audio_jump, audio_coin]
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
	
	#Extra : func _on_play_sfx_pressed() -> void:
	#_play_extra_sound_by_code()
	
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
	option_button_effect.add_item("Old Phone")

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
			var reverb = AudioEffectReverb.new()
			reverb.room_size = 0.8
			reverb.damping = 0.5
			reverb.spread = 1.0
			reverb.wet = 0.6
			AudioServer.add_bus_effect(sfx_bus_index, reverb)
			pass
		4:
			# Hiệu ứng loa nhỏ/đường dây cũ (Old Phone)
			# 1. Cắt âm để tạo cảm giác "thiếu chi tiết" (chỉ giữ dải Mid)
			var bandpass = AudioEffectBandPassFilter.new()
			bandpass.cutoff_hz = 1500 # Tần số trung tâm
			bandpass.resonance = 0.8  # Độ vang của màng loa nhỏ
			AudioServer.add_bus_effect(sfx_bus_index, bandpass)
			
		5:# 2. Làm méo tiếng rè rè
			var distortion = AudioEffectDistortion.new()
			distortion.mode = AudioEffectDistortion.MODE_LOFI 
			distortion.drive = 0.4 # Chỉnh độ méo từ 0 đến 1
			AudioServer.add_bus_effect(sfx_bus_index, distortion)
		6:
			var echo = AudioEffectDelay.new()
			echo.tap1_active = true
			echo.tap1_delay_ms = 300
			echo.feedback_active = true
			echo.feedback_level_db = -6.0
			AudioServer.add_bus_effect(sfx_bus_index, echo)
		7: 
			var pitch = AudioEffectPitchShift.new()
			pitch.pitch_scale = 0.5
			AudioServer.add_bus_effect(sfx_bus_index, pitch)
func _play_extra_sound_by_code() -> void:
	var dynamic_player = AudioStreamPlayer.new()
	
	var audio_file = load("res://click.wav")
	dynamic_player.stream = audio_file
	
	dynamic_player.bus = "SFX"
	
	add_child(dynamic_player)
	
	dynamic_player.play()
	
	dynamic_player.finished.connect(dynamic_player.queue_free)
