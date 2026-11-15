extends CharacterBody2D

# Assign "p1_jump" (W) or "p2_jump" (Up Arrow) in the Inspector
@export var jump_action: String = "p2_jump"

@export var base_jump_velocity: float = -150   # Starting jump power on a quick tap
@export var charge_rate: float = 350          # Extra jump power gained per second held

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var current_charge_time: float = 0.0
var is_charging: bool = false

func _physics_process(delta):
	# 1. Apply gravity when in the air
	if not is_on_floor():
		velocity.y += gravity * delta
		is_charging = false

	# 2. Start charging when the player's jump key is pressed on the floor
	if Input.is_action_just_pressed(jump_action) and is_on_floor():
		is_charging = true
		current_charge_time = 0.0

	# 3. Build up charge infinitely while holding the jump key
	if is_charging and Input.is_action_pressed(jump_action):
		current_charge_time += delta

	# 4. Launch when the jump key is released
	if is_charging and Input.is_action_just_released(jump_action):
		execute_jump()

	move_and_slide()

func execute_jump():
	# Subtract charge power because negative Y is upward in Godot 2D
	velocity.y = base_jump_velocity - (current_charge_time * charge_rate)
	
	# Reset charging state
	is_charging = false
	current_charge_time = 0.0
