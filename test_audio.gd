extends SceneTree

func _init():
	print("Testing audio setup...")
	var audio_db = load("res://data/audio/audio_database.tres")
	if not audio_db:
		print("ERROR: AudioDatabase not found!")
	else:
		print("Clips in DB:")
		for clip in audio_db.clips:
			if clip:
				print(" - ", clip.clip_id, ": ", clip.stream)
			else:
				print(" - NULL CLIP!")
				
	var am = load("res://scripts/audio/audio_manager.gd").new()
	if am:
		print("AudioManager loaded.")
	
	quit()
