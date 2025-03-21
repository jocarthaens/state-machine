extends Node

@export var entity: CharacterBody2D
@export var animator: AnimationPlayer
var face_direction: String = "down";
var direction: String = "down";
var is_hurt: bool = false;


func _ready() -> void:
	animator.animation_finished.connect(_on_animation_finished);


func _physics_process(delta: float) -> void:
	update_data();

func update_data():
	if !Input.is_action_pressed("ui_accept"):
		if entity.velocity.length() > 0:
			if  entity.velocity.x < 0: direction = "left";
			elif entity.velocity.x > 0: direction = "right";
			elif entity.velocity.y < 0: direction = "up";
			elif entity.velocity.y > 0: direction = "down";
	if not animator.current_animation.begins_with("roll_"):
		if Input.is_action_pressed("ui_down"): face_direction = "down";
		if Input.is_action_pressed("ui_up"): face_direction = "up";
		if Input.is_action_pressed("ui_left"): face_direction = "left";
		if Input.is_action_pressed("ui_right"): face_direction = "right";



func _on_animation_finished(anim_name: String):
	if (anim_name.begins_with("hurt")):
		is_hurt = false;

func _on_hurt_box_area_entered(area: Area2D) -> void:
	if is_hurt == false:
		is_hurt = true;
