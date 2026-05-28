extends Area2D

@export_file("*.tscn") var target_scene_path: String
@export var target_spawn_name: String = "SpawnPoint"

func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return

	GameManager.change_stage(target_scene_path, target_spawn_name)
