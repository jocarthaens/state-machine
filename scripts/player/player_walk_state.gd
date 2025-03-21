extends STATEState

@export var player: CharacterBody2D 
@export var animator: AnimationPlayer;

@onready var data = %PlayerData
var speed: int = 64;


func execute_state_logic(delta: float):
	movement();
	animator.play("walk_"+data.direction)

func movement():
	player.velocity = Input.get_vector("ui_left","ui_right","ui_up","ui_down");
	player.velocity *= speed;
	player.move_and_slide();
