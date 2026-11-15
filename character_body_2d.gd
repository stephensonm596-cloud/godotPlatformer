extends CharacterBody2D

@onready var player_node: CharacterBody2D = get_parent().get_node("player")

var speed: float = 100
var gravity: float = 50
var should_chase: bool = false

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
	if dir == 1 and(!$right_ray.is_colliding() or $right_wall_ray.is_colliding()):
		$AnimatedSprite2D.flip_h = false
		dir = -1
		
		
	if dir == -1 and(!$left_ray.is_colliding() or $left_wall_ray.is_colliding()):
		$AnimatedSprite2D.flip_h = true
		dir = 1
	
	
	
	velocity.x = lerp(velocity.x, dir * speed, 1.0 * delta)
	velocity.y += gravity
	
	
	
	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == player_node:
		$AnimatedSprite2D.play("attack")
		#get_tree().reload_current_scene()
		print("Dead")
