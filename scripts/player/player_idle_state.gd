extends STATEState

@export var animator: AnimationPlayer;

@onready var data = %PlayerData


func execute_state_logic(delta: float):
	animator.play("idle_"+data.face_direction)
