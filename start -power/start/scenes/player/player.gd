class_name Player
extends BaseCharacter

## Player character class that handles movement, combat, and state management
var is_invulnerable: bool = false
var has_blade: bool = false

var decorator_manager: DecoratorManager = null


func _ready() -> void:
	super._ready()
	fsm = FSM.new(self, $States, $States/Idle)
	
	GameManager.player = self
	
func can_attack() -> bool:
	if decorator_manager != null:
		return decorator_manager.can_blade_attack()
	return has_blade

func get_movement_speed():
	if decorator_manager != null:
		return decorator_manager.get_effective_movement_speed()
	return movement_speed
	
func get_jump_speed():
	if decorator_manager != null:
		decorator_manager.get_effective_jump_speed()
	return jump_speed
	
func speed_up(multiplier: float, duration: float) -> void:
	movement_speed = movement_speed * multiplier
	await get_tree().create_timer(duration).timeout
	movement_speed = movement_speed / multiplier

func collected_blade() -> void:
	has_blade = true
	set_animated_sprite($Direction/BladeAnimatedSprite2D)

#Collect powerup to apply to the player
func collect_powerup(powerup_id: String) -> void:
	decorator_manager.apply_powerup(powerup_id)
	
func save_state() -> Dictionary:
	return {
		"position": [global_position.x, global_position.y]
	}


func load_state(data: Dictionary) -> void:
	"""Load player state from checkpoint data"""
	if data.has("position"):
		var pos_array = data["position"]
		global_position = Vector2(pos_array[0], pos_array[1])
			
func _on_hurt_area_2d_hurt(_direction: Variant, _damage: Variant) -> void:
	fsm.current_state.take_damage(_damage)
