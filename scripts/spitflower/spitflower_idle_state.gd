extends STATEState

@onready var _data = %StateManager;


func execute_state_logic(delta):
	var animator: AnimationPlayer = _data.animator;
	var finished_anim: String = _data.get_finished_animation_name();
	var play_idle: bool = finished_anim.begins_with("retract") || finished_anim.begins_with("grow");
	
	if play_idle == true || animator.current_animation.begins_with("idle"):
		animator.play("idle");
