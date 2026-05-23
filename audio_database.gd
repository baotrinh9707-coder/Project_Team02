class_name AudioDatabase
extends Resource

## Database contains all audio clips in the game

var _clips: Array[AudioClip] = []
var _clip_map: Dictionary = {}

@export var clips: Array[AudioClip] = []:
	set(value):
		print("[AudioDatabase] Set clips array. Size: ", value.size())
		_clips = value
		_rebuild_map()
	get:
		return _clips


func _init():
	print("[AudioDatabase] Init")
	_rebuild_map()


func _rebuild_map() -> void:
	print("[AudioDatabase] Rebuild map")

	_clip_map.clear()

	for clip in _clips:
		if clip == null:
			print("[AudioDatabase] Skip null clip")
			continue

		print("[AudioDatabase] Checking clip: ", clip)

		if clip.id.is_empty():
			print("[AudioDatabase] Skip clip because id is empty")
			continue

		if _clip_map.has(clip.id):
			push_warning("Duplicate audio clip ID detected: " + clip.id)

		_clip_map[clip.id] = clip
		print("[AudioDatabase] Added clip ID: ", clip.id)

	print("[AudioDatabase] Total clips in map: ", _clip_map.size())
	print("[AudioDatabase] All clip IDs: ", _clip_map.keys())


## Get clip by ID
func get_clip(clip_id: String) -> AudioClip:
	print("[AudioDatabase] Get clip by ID: ", clip_id)

	if not _clip_map.has(clip_id):
		push_warning("Audio clip does not exist: " + clip_id)
		print("[AudioDatabase] Current available IDs: ", _clip_map.keys())
		return null

	print("[AudioDatabase] Found clip: ", clip_id)
	return _clip_map[clip_id] as AudioClip


## Add clip to database
func add_clip(clip: AudioClip) -> void:
	if clip == null:
		push_error("AudioClip is null!")
		return

	if clip.id.is_empty():
		push_error("AudioClip id is empty!")
		return

	print("[AudioDatabase] Add clip: ", clip.id)

	var replaced := false

	for i in range(_clips.size()):
		var existing: AudioClip = _clips[i]

		if existing == null:
			continue

		if existing.id == clip.id:
			print("[AudioDatabase] Replace existing clip: ", clip.id)
			_clips[i] = clip
			replaced = true
			break

	if not replaced:
		print("[AudioDatabase] Append new clip: ", clip.id)
		_clips.append(clip)

	_clip_map[clip.id] = clip

	print("[AudioDatabase] Add finished. Total clips: ", _clips.size())


## Check if clip exists
func has_clip(clip_id: String) -> bool:
	var exists := _clip_map.has(clip_id)

	print("[AudioDatabase] Has clip ", clip_id, ": ", exists)

	return exists


## Get all clip IDs
func get_all_clip_ids() -> Array:
	print("[AudioDatabase] Get all clip IDs: ", _clip_map.keys())
	return _clip_map.keys()
