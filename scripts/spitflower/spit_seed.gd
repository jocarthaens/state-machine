extends Area2D

var direction: Vector2 = Vector2(1,1);
var projectile_speed: float = 256;

var expire_timer: float = 1;
var _timer: float = 0;

func _physics_process(delta: float) -> void:
	global_position += direction.normalized() * projectile_speed * delta;
	set_rotation(direction.angle());
	_timer += delta;
	if _timer >= expire_timer:
		queue_free();
