extends STATEManager

@export var spitflower: StaticBody2D;
@export var animator: AnimationPlayer;
@export var text_display: Label;

var attack_direction: Vector2 = Vector2.ZERO;
var face_direction: String = "down";

var _is_hit: bool = false;
var _is_dormant: bool = false;
var _timer: float = 0;
var dormant_timer: float = 10.0;

var _mode: String = "idle" # states: idle, alert, sleep
var player: Area2D = null;
var attack_dist: int = 80;

@onready var spit_seed = preload("res://scenes/spitseed.tscn");
var seed_ammo: Area2D = null;


var _finished_animation: String = "";

func get_finished_animation_name() -> String:
	return _finished_animation;



func _ready():
	animator.play("idle")
	animator.animation_finished.connect(_on_animation_finished);



func _physics_process(delta: float) -> void:
	update_data(delta);
	update_state_machine(delta);


func update_data(delta: float):
	
	if player != null:
		var spit_pos: Vector2 = %AttackMarker.global_position;
		attack_direction = (player.get_global_position() - spit_pos).normalized();
		var deg_angle: float = rad_to_deg(attack_direction.angle());
		
		if deg_angle >= 135 && deg_angle <= 180 || deg_angle <= -135 && deg_angle >= -180:
			face_direction = "left";
		elif deg_angle > -135 && deg_angle < -45:
			face_direction = "up";
		elif deg_angle >= -45 && deg_angle <= 45:
			face_direction = "right";
		elif deg_angle > 45 && deg_angle < 135:
			face_direction = "down";
	
	if _is_dormant == true:
		_timer += delta;
		if _timer >= dormant_timer:
			_is_hit = false;
			if _finished_animation.begins_with("grow"):
				_timer = 0;
				_is_dormant = false;
	


func transition_logic() -> String:
	var target_dist: float = abs( (player.get_global_position() - spitflower.get_global_position()).length() ) if player != null else -1;
	
	if _is_hit == true:
		if _is_dormant == false:
			_is_dormant = true;
			#_timer = 0;
			#_mode = "sleep"
		return "Dormant";
	elif target_dist > 0 && target_dist <= attack_dist || animator.current_animation.begins_with("spit"):
		return "Spit";
	elif player != null && target_dist > attack_dist:
		return "Alert";
	elif _is_dormant == false:
		return "Idle";
	return "Idle";



func enter_state(new_state: String, old_state: String):
	text_display.text = new_state;
	
	if (new_state == "Alert" && old_state == "Idle"):
		animator.play("alert")
		return;
	elif (new_state == "Idle"):
		match old_state:
			"Alert", "Spit":
				animator.play("retract");
			"Dormant":
				animator.play("grow");
			_:
				pass;
		return;
	elif (new_state == "Dormant"):
		animator.play("eliminated")
		return;

func exit_state(old_state: String, new_state: String): pass








func load_projectile():
	seed_ammo = spit_seed.instantiate();

func spit_projectile():
	if is_instance_valid(seed_ammo) || seed_ammo != null:
		seed_ammo.direction = attack_direction
		seed_ammo.global_position = %AttackMarker.get_global_position();
		get_tree().get_current_scene().get_node('/root').add_child(seed_ammo);
		seed_ammo = null;







func _on_animation_finished(anim_name: String):
	_finished_animation = anim_name;


func _on_hurt_box_area_entered(area: Area2D) -> void:
	_is_hit = true;


func _on_sensor_area_entered(area: Area2D) -> void:
	player = area;

func _on_sensor_area_exited(area: Area2D) -> void:
	if area == player:
		player = null;
