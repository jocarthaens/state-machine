extends STATEState

@export var player: CharacterBody2D 
@export var animator: AnimationPlayer;

@onready var data = %PlayerData


func execute_state_logic(delta: float):
	animator.play("hurt_down")
	#animator.play("hurt_"+data.direction)
