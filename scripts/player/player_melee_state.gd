extends STATEState

@export var animator: AnimationPlayer;
@onready var data = %PlayerData

var melee_finished = false;

func _ready() -> void:
	animator.animation_finished.connect(animate_finished);

func execute_state_logic(delta: float):
	if !animator.current_animation.begins_with("melee") or melee_finished == true:
		animator.play("melee_"+data.face_direction, -1, 2.5);
		melee_finished = false;

func animate_finished(anim_name : String):
	if anim_name.begins_with("melee"):
		melee_finished = true;
		return;
	melee_finished = false;
