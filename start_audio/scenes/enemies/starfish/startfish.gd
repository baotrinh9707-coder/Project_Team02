extends EnemyCharacter

func _ready() -> void:
	fsm = FSM.new(self, $States, $States/Run)
	super._ready()

func attack() -> void:
	fsm.change_state(fsm.states.attack)
