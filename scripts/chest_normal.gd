extends InteractiveArea2D

@export var coin_reward: int = 5
@export var coin_scene: PackedScene

var is_opened: bool = false

@onready var animated_sprite: AnimatedSprite2D = $normal_chest

func _ready():
	super._ready()
	interacted.connect(_on_interacted)
	animated_sprite.play("close")


func _on_interacted():
	attempt_open_chest()


func attempt_open_chest():
	if is_opened:
		return

	if GameManager.inventory_system.has_key():
		open_chest()


func open_chest():
	
	is_opened = true
	if InteractiveArea2D.current_area == self:
		InteractiveArea2D.current_area = null

	set_process_unhandled_input(false)
	GameManager.inventory_system.use_key()
	animated_sprite.play("open")
	await animated_sprite.animation_finished
	GameManager.inventory_system.add_coin(coin_reward)
	print("Chest opened! You received ", coin_reward, " coin!")
	
	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.8)

	await tween.finished
	queue_free()
