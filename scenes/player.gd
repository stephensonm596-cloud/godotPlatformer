
extends CharacterBody2D

@export var speed: float = 250.0
@export var jump_velocity: float = -400.0
@export var gravity: float = 980.0

func _physics_process(delta: float) -> void:
	# Apply gravity while the player is in the air.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Read left/right input.
	var direction := Input.get_axis("move_left", "move_right")

	# Move horizontally.
	velocity.x = direction * speed

	# Jump only while standing on the ground.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	# Apply movement and handle collisions.
	move_and_slide()
