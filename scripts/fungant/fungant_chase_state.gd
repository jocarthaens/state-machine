extends STATEState

@onready var _data = %StateManager;

func execute_state_logic(delta: float):
	var animator: AnimationPlayer = _data.animator;
	var player_pos: Vector2 = _data.player.get_global_position();
	var fungant: CharacterBody2D = _data.fungant
	var fungant_pos: Vector2 = fungant.get_global_position();
	var chase_speed: float = _data.chase_speed;
	
	fungant.velocity = (player_pos - fungant_pos).normalized() * chase_speed;
	fungant.move_and_slide();
	
	animator.play("walk_"+_data.face_direction, -1, 3.0);
