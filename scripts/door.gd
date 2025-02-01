class_name Door
extends StaticBody2D

@export var default_is_open: bool = false
@export var close_delay: float = 2

@onready var sprite_2d: Sprite2D = %Sprite2D
@onready var indicator_collision_shape_2d: CollisionShape2D = $IndicatorCollisionShape2D
@onready var door_collision_shape_2d: CollisionShape2D = $DoorCollisionShape2D
@onready var close_timer: Timer = %CloseTimer

enum DoorState {
	OPEN,
	CLOSED,
	CLOSING,
}

@export var state: DoorState = DoorState.OPEN:
	set(new):
		state = new
		match state:
			DoorState.OPEN:
				sprite_2d.frame = 0
				door_collision_shape_2d.set_deferred("disabled", true)
				indicator_collision_shape_2d.set_deferred("disabled", true)
			DoorState.CLOSING:
				pass
			DoorState.CLOSED:
				sprite_2d.frame = 1
				door_collision_shape_2d.set_deferred("disabled", false)
				indicator_collision_shape_2d.set_deferred("disabled", false)
				
var can_close: bool = true

func open():
	state = DoorState.OPEN

func close():
	close_timer.start(close_delay)
	state = DoorState.CLOSING
	
func _ready() -> void:
	if default_is_open: open() 
	else: close()

func _on_safe_area_body_entered(body: Node2D) -> void:
	print("NO")
	can_close = false

func _on_safe_area_body_exited(body: Node2D) -> void:
	print("YESS")
	can_close = true
	if state == DoorState.CLOSING:
		state = DoorState.CLOSED

func _on_close_timer_timeout() -> void:
	if not can_close:
		return
	state = DoorState.CLOSED
