extends Area2D

@onready var sprite: AnimatedSprite2D = $animated_normal_chest

var opened := false

func _ready() -> void:
	sprite.play("chest_close")
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if opened:
		return

	if not body.is_in_group("player"):
		return

	opened = true

	sprite.play("chest_open")
	await sprite.animation_finished

	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 1.0)

	await tween.finished
	queue_free()
