extends CharacterBody2D

@export var speed = 300.0
@export var min_jump_velocity = -200 # Jump power for a quick tap
@export var max_jump_velocity = -425 # Jump power at full charge
@export var max_charge_time = 1     # Max seconds you can hold spacebar
@export var auto_jump_at_max = true    # Launch automatically when fully charged?

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var current_charge_time = 0.0
var is_charging = false

func _physics_process(delta):
	# 1. Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta
		is_charging = false # Cancel charge if you walk off a ledge

	# 2. Start charging when spacebar is pressed on the floor
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		is_charging = true
		current_charge_time = 0.0

	# 3. Build up charge while holding spacebar
	if is_charging and Input.is_action_pressed("ui_accept"):
		current_charge_time += delta
		
		# Clamp the charge to the maximum hold limit
		if current_charge_time >= max_charge_time:
			current_charge_time = max_charge_time
			if auto_jump_at_max:
				execute_jump()

	# 4. Launch when spacebar is released
	if is_charging and Input.is_action_just_released("ui_accept"):
		execute_jump()

	# 5. Horizontal movement (optional: stop moving while charging)
	var direction = Input.get_axis("ui_left", "ui_right")
	if is_charging:
		velocity.x = move_toward(velocity.x, 0, speed) # Locks player in place while charging
	elif direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()

func execute_jump():
	# Calculate percentage of charge (0.0 to 1.0)
	var charge_ratio = current_charge_time / max_charge_time
	
	# Smoothly blend between min and max jump power
	velocity.y = lerp(min_jump_velocity, max_jump_velocity, charge_ratio)
	
	# Reset charging state
	is_charging = false
	current_charge_time = 0.0
