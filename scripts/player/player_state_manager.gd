extends STATEManager

@export var player: CharacterBody2D;
@export var animator: AnimationPlayer;
@export var text_display: Label;
@onready var data = %PlayerData;

func _physics_process(delta: float) -> void:
	update_state_machine(delta);


func transition_logic():
	if data.is_hurt == true || animator.current_animation.begins_with("hurt"):
		return "Hurt";
	elif (Input.is_action_just_pressed("roll") && curr_state != "Roll") || animator.current_animation.begins_with("roll"):
		return "Roll";
	elif Input.is_action_pressed("ui_accept") || animator.current_animation.begins_with("melee"):
		return "Melee";;
	elif Input.is_action_pressed("movement"):
		return "Walk";
	return "Idle";

func enter_state(new_state: String, old_state: String):
	animator.pause();
	text_display.text = new_state;
