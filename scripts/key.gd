extends InteractiveArea2D

@export var key_amount: int = 1

func _ready() -> void:
	interaction_available.connect(_on_interaction_available)
	super._ready()


func collect_key() -> void:
	GameManager.inventory_system.add_key(key_amount)
	queue_free()


func _on_interaction_available(body: Node2D) -> void:
	collect_key()
