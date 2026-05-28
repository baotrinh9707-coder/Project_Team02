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
@onready var audio_jump = $AudioStreamPlayer_Jump
@onready var audio_coin = $AudioStreamPlayer_Coin

# SFX array to random play
var sfx_players: Array[AudioStreamPlayer] = []

var sfx_bus_index: int = -1
# Extra: Initialize AudioStreamPlayer by code
var audio_music: AudioStreamPlayer


func _ready() -> void:
	_setup_sfx()
	_setup_ui_connections()
	_setup_effects()

func _setup_sfx() -> void:
	"""Initialize SFX players and initial configuration"""
	# Assign streams and buses
	audio_jump.stream = load("res://assets/audio/sfx/player/jump.wav")
	audio_jump.bus = "SFX"
	audio_coin.stream = load("res://assets/audio/sfx/collect/coin.mp3")
	audio_coin.bus = "SFX"
	
	# Add to array
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
	audio_music = AudioStreamPlayer.new()
	audio_music.name = "AudioStreamPlayer_Music_Code"
	audio_music.stream = load("res://assets/audio/music/music.ogg")
	if audio_music.stream is AudioStreamOggVorbis:
		audio_music.stream.loop = true
	audio_music.bus = "Music"
	add_child(audio_music)
	_apply_music_volume(slider_music_volume.value)


func _on_play_music_pressed() -> void:
	"""Play background music"""
	if not audio_music.playing:
		audio_music.play()


func _on_stop_music_pressed() -> void:
	"""Stop background music"""
	if audio_music.playing:
		audio_music.stop()


func _apply_music_volume(_value: float) -> void:
	"""Apply volume to music player"""
	var music_bus_index = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_linear(music_bus_index, _value)
	print("Music volume: ", _value)


func _on_music_volume_changed(_value: float) -> void:
	"""Callback when slider Music volume changes"""
	_apply_music_volume(_value)


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
	option_button_effect.add_item("Telephone (Extra)")


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
			var reverb = AudioEffectReverb.new()
			reverb.room_size = 1.0
			reverb.damping = 0.1
			reverb.wet = 0.8
			reverb.dry = 0.5
			reverb.predelay_msec = 250
			reverb.predelay_feedback = 0.6
			reverb.spread = 1.0
			reverb.hipass = 0.1
			AudioServer.add_bus_effect(sfx_bus_index, reverb)
		4:
			var distortion = AudioEffectDistortion.new()
			distortion.mode = AudioEffectDistortion.MODE_LOFI
			distortion.drive = 0.9
			AudioServer.add_bus_effect(sfx_bus_index, distortion)
			var lowpass = AudioEffectLowPassFilter.new()
			lowpass.cutoff_hz = 1500
			AudioServer.add_bus_effect(sfx_bus_index, lowpass)
