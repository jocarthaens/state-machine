extends STATEState

@onready var _data = %StateManager;

func execute_state_logic(delta: float):
	_data.animator.play("fume_"+_data.face_direction);
