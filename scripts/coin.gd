extends InteractiveArea2D

@export var coin_amount: int = 1

func _ready() -> void:
	interaction_available.connect(_on_interaction_available)
	super._ready()


func collect_coin() -> void:
	GameManager.inventory_system.add_coin(coin_amount)
	queue_free()


func _on_interaction_available(body:Node2D) -> void:
	if not body.is_in_group("player"):
		return

	collect_coin()
