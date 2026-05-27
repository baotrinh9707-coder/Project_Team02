extends Node2D

var is_open: bool = false
var player_near: bool = false
var is_animating: bool = false

@onready var animated_sprite: AnimatedSprite2D = $door
@onready var door_collision: CollisionShape2D = $StaticBody2D/CollisionShape2D
@onready var interaction_area: InteractiveArea2D = $InteractionArea


func _ready() -> void:
	animated_sprite.play("closed")

	interaction_area.interacted.connect(_on_interacted)
	interaction_area.interaction_available.connect(_on_interaction_available)
	interaction_area.interaction_unavailable.connect(_on_interaction_unavailable)


func _on_interaction_available(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return

	player_near = true


func _on_interaction_unavailable() -> void:
	player_near = false

	if is_open:
		close_door()


func _on_interacted() -> void:
	if not player_near:
		return

	if is_animating:
		return

	if not is_open:
		open_door()


func open_door() -> void:
	is_animating = true
	is_open = true

	animated_sprite.play("open")
	await animated_sprite.animation_finished

	animated_sprite.play("opened")
	door_collision.set_deferred("disabled", true)

	is_animating = false


func close_door() -> void:
	is_animating = true
	is_open = false

	door_collision.set_deferred("disabled", false)

	animated_sprite.play("close")
	await animated_sprite.animation_finished

	animated_sprite.play("closed")

	is_animating = false
