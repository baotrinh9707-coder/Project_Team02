extends EnemyCharacter

func _ready() -> void:
	# Bỏ qua va chạm với chính cơ thể mình
	$Direction/FrontRayCast2D.add_exception(self)
	$Direction/DownRayCast2D.add_exception(self)
	
	fsm = FSM.new(self, $States, $States/Run)
	super._ready()
