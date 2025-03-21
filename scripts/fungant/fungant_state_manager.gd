extends STATEManager

@export var fungant: CharacterBody2D;
@export var animator: AnimationPlayer;
@export var text_display: Label;

var face_direction: String = "right";
var _is_hit: bool = false;
var _is_dormant: bool = false;
var player: Area2D = null;
var attack_dist: int = 10;

var idle_time: float = 3.0;
var wander_time: float = 5.0;
var sleep_time: float = 10.0;
var _timer: float = 0.0;
var _mode: String = "idle"; # states: idle, wander, sleep

var random_wander_pos: Vector2 = Vector2();
var _spawn_pos: Vector2;
var dist_from_spawn: int = 96;
var wander_speed: int = 48;
var chase_speed: int = 80;

var _finished_animation: String = "";

func get_finished_animation_name() -> String:
	return _finished_animation;

func get_spawn_point() -> Vector2:
	return _spawn_pos;


func _ready():
	_spawn_pos = fungant.position;
	randomize();
	_timer = randf_range(0, idle_time);
	_mode = "idle";
	animator.animation_finished.connect(_on_animation_finished);




func _physics_process(delta: float) -> void:
	update_data(delta);
	update_state_machine(delta);
	pass


func update_data(delta: float):
	if fungant.velocity.length() > 0:
		if fungant.velocity.x < 0:
			face_direction = "left";
		elif fungant.velocity.x > 0:
			face_direction = "right";
	
	_timer += delta; 
	match _mode:
		"idle":
			if _timer >= idle_time:
				_timer = 0;
				_mode = "wander";
		"wander":
			if (fungant.global_position - random_wander_pos).length() <= 1 or _timer >= wander_time:
				_timer = 0;
				_mode = "idle";
		"sleep":
			if _timer >= sleep_time:
				_is_hit = false;
				if _finished_animation.begins_with("rise_"):
					_timer = 0;
					_mode = "idle";
					_is_dormant = false;








func transition_logic():
	var target_dist: float = abs( (player.get_global_position() - fungant.get_global_position()).length() ) if player != null else -1;
	
	if _is_hit == true:
		if _is_dormant == false:
			_is_dormant = true;
			_timer = 0;
			_mode = "sleep"
		return "Dormant";
	elif target_dist > 0 && target_dist <= attack_dist || animator.current_animation.begins_with("fume"):
		return "Fumigate";
	elif player != null && target_dist > attack_dist:
		return "Chase";
	elif _is_dormant == false:
		match _mode:
			"idle":
				return "Idle";
			"wander":
				return "Wander";
			_:
				return "Idle";
	return "Idle";

func enter_state(new_state: String, old_state: String):
	text_display.text = new_state;
	
	if new_state == "Dormant":
		animator.play("sleep_"+face_direction);
	if new_state == "Wander":
		random_wander_pos = _spawn_pos + Vector2(randf_range(-dist_from_spawn, dist_from_spawn), randf_range(-dist_from_spawn, dist_from_spawn));
		while (random_wander_pos.distance_to(_spawn_pos) > dist_from_spawn):
			randomize();
			random_wander_pos = _spawn_pos + Vector2(randi_range(-dist_from_spawn, dist_from_spawn), randi_range(-dist_from_spawn, dist_from_spawn));

func exit_state(old_state: String, new_state: String):
	if old_state == "Dormant" && new_state == "Idle":
		animator.play("rise_"+face_direction);











func _on_animation_finished(anim_name: String):
	_finished_animation = anim_name;



func _on_hurt_box_area_entered(area: Area2D) -> void:
	_is_hit = true;

func _on_sensor_area_entered(area: Area2D) -> void:
	player = area;

func _on_sensor_area_exited(area: Area2D) -> void:
	if area == player:
		player = null;
