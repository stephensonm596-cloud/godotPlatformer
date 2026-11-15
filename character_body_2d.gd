extends CharacterBody2D

@onready var player_node: CharacterBody2D = get_parent().get_node("player")
var player_scanned: CharacterBody2D = null

var speed: float = 100
var gravity: float = 50

enum State {IDLE,CHASE}
var current_state = State.IDLE

@export_range(-1,1,) var dir: int = 1


func _ready() -> void:
	if dir == 0:
		dir = 1
		$Sprite2D.flip_h = false if dir == 1 else true
	$AnimatedSprite2D.autoplay = "move"
	$AnimatedSprite2D.animation = "move"
	$AnimatedSprite2D.play()



func _physics_process(delta: float) -> void:
	if(!$AnimatedSprite2D.is_playing()):
		$AnimatedSprite2D.animation = "move"
		$AnimatedSprite2D.play()
	
	behaviour_tree()
	
	
	velocity.y += gravity
	
	
	
	move_and_slide()





func patrol():
	#print("patrol")
	if dir == 1 and(!$right_ray.is_colliding() or $right_wall_ray.is_colliding()):
		$AnimatedSprite2D.flip_h = false
		dir = -1
		
		
	if dir == -1 and(!$left_ray.is_colliding() or $left_wall_ray.is_colliding()):
		$AnimatedSprite2D.flip_h = true
		dir = 1
		
	velocity.x = lerp(velocity.x, dir * speed, 0.1)

func chase():

	if player_scanned == null:
		return

	var direction = sign(player_scanned.global_position.x - global_position.x)

	if direction == 0:
		velocity.x = 0
		return

	dir = int(direction)

	$AnimatedSprite2D.flip_h = dir == 1

	# Check ground and walls
	if dir == 1:
		if $right_ray.is_colliding() and !$right_wall_ray.is_colliding():
			velocity.x = speed
		else:
			velocity.x = 0

	elif dir == -1:
		if $left_ray.is_colliding() and !$left_wall_ray.is_colliding():
			velocity.x = -speed
		else:
			velocity.x = 0


func behaviour_tree():

	
	if current_state == State.CHASE:
		chase()
	
	elif current_state == State.IDLE:
		patrol()




func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == player_node:
		$AnimatedSprite2D.play("attack")
		player_node.damagePlayer(20,global_position)


func _on_enter_area_body_entered(body: Node2D) -> void:
	if body == player_node:
		print("Player detected")
		player_scanned = player_node
		current_state = State.CHASE
		print(current_state)


func _on_player_detectionexit_body_exited(body: Node2D) -> void:
	if body == player_node:
		print("Player exited")
		player_scanned = null
		current_state = State.IDLE
		print(current_state)
