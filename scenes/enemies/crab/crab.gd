extends EnemyCharacter

func _ready() -> void:
	# Bỏ qua va chạm với chính cơ thể mình
	$Direction/FrontRayCast2D.add_exception(self)
	$Direction/DownRayCast2D.add_exception(self)
	
	fsm = FSM.new(self, $States, $States/Run)
	super._ready()

func _on_hurt_area_2d_hurt(direction: Variant, damage: Variant) -> void:
	if fsm.current_state and fsm.current_state.has_method("take_damage"):
		fsm.current_state.take_damage(damage)
