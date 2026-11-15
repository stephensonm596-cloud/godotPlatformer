
extends CharacterBody2D

@export var speed: float = 250.0
@export var jump_velocity: float = -400.0
@export var gravity: float = 980.0
@export var health: int = 100

@export var knockback_force: Vector2 = Vector2(300, 400)

@export var push_force_horizontal := 1200.0
@export var push_force_vertical := 1200.0
var vertical_recoil = 200
var is_knocked_back: bool = false

func _physics_process(delta: float) -> void:

	if not is_on_floor():
		velocity.y += gravity * delta
	var direction := Input.get_axis("move_left", "move_right")	
	if not is_knocked_back:
		velocity.x = direction * speed

		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = jump_velocity
	move_and_slide()
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
			


func damagePlayer(damageValue: int, enemy_position: Vector2):
	health -= damageValue

	var direction = sign(global_position.x - enemy_position.x)

	if direction == 0:
		direction = 1

	velocity.x = direction * knockback_force.x
	velocity.y = -knockback_force.y

	is_knocked_back = true

	await get_tree().create_timer(0.2).timeout
	is_knocked_back = false

func _process(delta: float) -> void:
	if health <= 0:
		get_tree().reload_current_scene()
		print("Dead")
