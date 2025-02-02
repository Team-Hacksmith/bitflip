class_name Moveable
extends CharacterBody2D

@export var gravity: float = 10.0
@export var max_fall_speed: float = 1000.0
@export var friction: float = 0.9

func _physics_process(delta):
	# Apply gravity
	if !is_on_floor():
		velocity.y += gravity
		if velocity.y > max_fall_speed:
			velocity.y = max_fall_speed

	# Apply friction to horizontal movement
	velocity.x *= friction
	
	# Move the object
	move_and_slide()
