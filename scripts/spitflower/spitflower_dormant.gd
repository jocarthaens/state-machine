extends STATEState

@onready var _data = %StateManager;


func execute_state_logic(delta):
	var animator: AnimationPlayer = _data.animator;
	var finished_anim: String = _data.get_finished_animation_name()
	
	if finished_anim.begins_with("eliminated") || animator.current_animation.begins_with("dormant"):
		_data.animator.play("dormant");
