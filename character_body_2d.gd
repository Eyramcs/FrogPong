extends CharacterBody2D


const SPEED = 300.0
const MAX_JUMP_VELOCITY = -800.0
var StoredVelocity = 0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	
	# Handle jump.
	if Input.is_action_pressed('ui_accept') and is_on_floor() and (StoredVelocity>=MAX_JUMP_VELOCITY):
		StoredVelocity -= 100
		print(StoredVelocity)
	elif Input.is_action_just_released('ui_accept'):
		velocity.y = StoredVelocity
		StoredVelocity = 0

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.

	move_and_slide()
