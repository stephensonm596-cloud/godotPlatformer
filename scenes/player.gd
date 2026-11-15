
extends CharacterBody2D

@export var speed: float = 250.0
@export var jump_velocity: float = -400.0
@export var gravity: float = 980.0
@export var push_force_horizontal := 1200.0
@export var push_force_vertical := 1200.0
var vertical_recoil = 200
var jump_count = 0
func _physics_process(delta: float) -> void:
	# Apply gravity while the player is in the air.
	if not is_on_floor():
		velocity.y += gravity * delta
	else :
		jump_count = 0
	# Read left/right input.
	var direction := Input.get_axis("move_left", "move_right")

	# Move horizontally.
	velocity.x = direction * speed
	
	move_and_slide()
	# Jump only while standing on the ground.
	if Input.is_action_just_pressed("jump") and jump_count < 2:
		jump_count += 1
		velocity.y = jump_velocity
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var body = collision.get_collider()

		if body is RigidBody2D:
			var normal = collision.get_normal()
			if body.is_in_group("pushable_platforms"):

				if abs(normal.x) > 0.7:
					var push_direction = -normal.x
		
					if sign(direction) == sign(push_direction):
						body.apply_central_force(
							Vector2(push_direction * push_force_horizontal, 0)
						)
					
			if abs(normal.y) > 0.7:
				var push_direction = -normal.y
	
				if sign(direction) == sign(push_direction):
					body.apply_central_force(
						Vector2(push_direction * push_force_horizontal, 0)
					)
				velocity += normal * vertical_recoil
			
			

	# Apply movement and handle collisions.
	
func handle_platform_collision(collision, platform):
	var normal = collision.get_normal()

	# Player pushes platform from the side
	if abs(normal.x) > 0.7:
		var push_direction = Vector2(-normal.x, 0)

		platform.push(push_direction)
