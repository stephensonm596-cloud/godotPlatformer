
extends AnimatableBody2D

@export var push_speed := 150.0
@export var friction := 500.0

var push_velocity := Vector2.ZERO

func _physics_process(delta):
	# Move the platform
	position += push_velocity * delta

	# Slowly stop moving
	push_velocity = push_velocity.move_toward(
		Vector2.ZERO,
		friction * delta
	)

func push(direction: Vector2):
	push_velocity += direction * push_speed
