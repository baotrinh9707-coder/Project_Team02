extends Resource
class_name AudioClip

@export var id: String = ""
@export var stream: AudioStream
@export var bus: String = "SFX"
@export var volume_db: float = 0.0

@export var randomize_pitch: bool = false
@export var pitch_min: float = 0.9
@export var pitch_max: float = 1.1
