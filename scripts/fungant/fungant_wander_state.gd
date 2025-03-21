extends STATEState

@onready var _data = %StateManager;

func execute_state_logic(delta: float):
	var fungant: CharacterBody2D = _data.fungant;
	var animator: AnimationPlayer = _data.animator;
	var raycast: RayCast2D = %RayCast2D;
	
	var random_pos: Vector2 = _data.random_wander_pos;
	var spawn_point: Vector2 = _data.get_spawn_point();
	var dist_from_spawn: int = _data.dist_from_spawn;
	var wander_speed: float = _data.wander_speed;
	
	if raycast.is_colliding():
		random_pos = spawn_point + Vector2(randf_range(-dist_from_spawn, dist_from_spawn), randf_range(-dist_from_spawn, dist_from_spawn));
		while (random_pos.distance_to(spawn_point) > dist_from_spawn):
			randomize();
			random_pos = spawn_point + Vector2(randi_range(-dist_from_spawn, dist_from_spawn), randi_range(-dist_from_spawn, dist_from_spawn));
		_data.random_wander_pos = random_pos;
	
	var direction: Vector2 = (random_pos - fungant.get_global_position()).normalized() * wander_speed;
	fungant.velocity = direction;
	fungant.move_and_slide();
	raycast.set_rotation(direction.angle())
	
	animator.play("walk_"+_data.face_direction);
