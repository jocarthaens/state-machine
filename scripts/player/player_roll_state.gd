extends STATEState

@export var player: CharacterBody2D;
@export var animator: AnimationPlayer;

@onready var data = %PlayerData

var roll_velocity = Vector2.DOWN;
var roll_speed = 160;
var locked_direction = "down";


func execute_state_logic(delta: float):
	roll_movement();
	animator.play("roll_"+data.face_direction)

func roll_movement():
	match (data.face_direction):
		"down":
			roll_velocity = Vector2.DOWN;
		"up":
			roll_velocity = Vector2.UP;
		"right":
			roll_velocity = Vector2.RIGHT;
		"left":
			roll_velocity = Vector2.LEFT;
		_:
			roll_velocity = Vector2.ZERO;
	player.velocity = roll_velocity * roll_speed;
	player.move_and_slide();
