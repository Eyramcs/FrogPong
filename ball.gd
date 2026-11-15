extends CharacterBody2D

@export var start_speed: float = 50
@export var speed_increment: float = 100
@export var max_bounce_angle: float = 60.0 # Maximum deflection angle in degrees

var speed: float = 0.0
var direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	reset_ball()

func reset_ball() -> void:
	position = get_viewport_rect().size / 2.0
	speed = start_speed
	
	var random_x = 1.0 if randi() % 2 == 0 else -1.0
	var random_y = randf_range(-0.3, 0.3)
	direction = Vector2(random_x, random_y).normalized()

func _physics_process(delta: float) -> void:
	var collision = move_and_collide(direction * speed * delta)
	if collision:
		var collider = collision.get_collider()
		
		if collider.is_in_group("paddles"):
			handle_paddle_bounce(collider)
			speed += speed_increment
		else:
			# Normal bounce off top and bottom walls
			direction = direction.bounce(collision.get_normal())

func handle_paddle_bounce(paddle: Node2D) -> void:
	# 1. Get the paddle's height from its CollisionShape2D
	var shape = paddle.get_node("CollisionShape2D").shape as RectangleShape2D
	var paddle_height = shape.size.y * paddle.scale.y
	
	# 2. Calculate relative hit position (-1.0 at top edge, 0.0 at center, 1.0 at bottom edge)
	var relative_y = global_position.y - paddle.global_position.y
	var normalized_y = clamp(relative_y / (paddle_height / 2.0), -1.0, 1.0)
	
	# 3. Convert to a bounce angle in radians
	var bounce_angle = normalized_y * deg_to_rad(max_bounce_angle)
	
	# 4. Reverse horizontal direction and apply the new angle
	var new_dir_x = -sign(direction.x)
	direction = Vector2(new_dir_x * cos(bounce_angle), sin(bounce_angle)).normalized()
