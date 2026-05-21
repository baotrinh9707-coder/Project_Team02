extends AnimatedSprite2D

@export var animation_name: String = "default"

func _ready():
	if sprite_frames.has_animation(animation_name):
		sprite_frames.set_animation_loop(animation_name, true)
		play(animation_name)
	else:
		push_warning("Animation not found: " + animation_name)
