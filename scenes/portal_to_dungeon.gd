extends InteractiveArea2D

@export_file("*.tscn") var target_stage_path: String
@export var target_portal_name: String = ""

var is_opening: bool = false

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	interacted.connect(_on_interacted)
	animated_sprite.play("closed")
	super._ready()


func _on_interacted() -> void:
	if is_opening:
		return

	open_portal()


func open_portal() -> void:
	is_opening = true

	animated_sprite.play("open")
	await animated_sprite.animation_finished

	GameManager.change_stage(target_stage_path, target_portal_name)
