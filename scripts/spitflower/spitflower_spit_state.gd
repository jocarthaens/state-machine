extends STATEState

@onready var _data = %StateManager;


func execute_state_logic(delta):
	var animator: AnimationPlayer = _data.animator;
	animator.play("spit_"+_data.face_direction);
	
	var load_frame: bool = %Sprites.frame == 70 || %Sprites.frame == 56 || %Sprites.frame == 42 || %Sprites.frame == 28;
	var spit_frame: bool = %Sprites.frame == 75 || %Sprites.frame == 61 || %Sprites.frame == 47 || %Sprites.frame == 33;
	
	if load_frame == true:
		_data.load_projectile();
	if spit_frame == true:
		_data.spit_projectile();
