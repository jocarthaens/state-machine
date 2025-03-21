extends STATEState

@onready var _data = %StateManager;

func execute_state_logic(delta: float):
	var animator: AnimationPlayer = _data.animator;
	var fungant: CharacterBody2D = _data.fungant;
	var finished_anim: String = _data.get_finished_animation_name()
	
	fungant.velocity = Vector2.ZERO;
	
	if finished_anim.begins_with("sleep_") || animator.current_animation == "dormant":
		animator.play("dormant");
