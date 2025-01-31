class_name Cat
extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var auto_move_timer: Timer = $AutoMoveTimer

@export var auto_move_time := 30.0 #seconds
@export var speed := 250
@export var gravity := 30
@export var gravity_dir := Vector2.DOWN

@export var position_markers_parent: Node2D

var position_markers: Array[Vector2] = []

var wall_walking := false
var is_fleeing := false
var current_index = 0

func _ready() -> void:
	assert(position_markers_parent)
	for marker: Marker2D in position_markers_parent.get_children():
		position_markers.push_back(marker.global_position)

func _physics_process(_delta: float) -> void:
	velocity += gravity * gravity_dir
	
	wall_walking = is_on_wall()
		
	if wall_walking:
		gravity_dir = -get_wall_normal()
		velocity.y = -speed
	else:
		gravity_dir = Vector2.DOWN
		velocity.x = speed if is_fleeing else 0
	
	#if is_on_ceiling():
		#gravity_dir = Vector2.UP
		#velocity.x = -speed if is_fleeing else 0
		
	sprite.rotation = gravity_dir.angle() - PI/2
	
	if is_fleeing:
		sprite.play("run")
	else:
		sprite.play("idle")
	
	move_and_slide()
	

func move_to_next_marker():
	auto_move_timer.stop()
	if len(position_markers) - 1 > current_index and is_fleeing:
		is_fleeing = false
		current_index += 1
		global_position = position_markers[current_index]
	

func _on_spook_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		auto_move_timer.start(auto_move_time)
		is_fleeing = true


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	move_to_next_marker()


func _on_auto_move_timer_timeout() -> void:
	move_to_next_marker()
