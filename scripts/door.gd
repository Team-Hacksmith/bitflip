class_name Door
extends StaticBody2D

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

@export var state: DoorState = DoorState.CLOSED:
	set(new):
		state = new
		_on_state_changed(new)

				
var can_close: bool = true
var bodies_stack: Array[Node2D] = []

func _ready() -> void:
	_on_state_changed(state)
	
func _on_state_changed(state: DoorState):
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
	
func open():
	state = DoorState.OPEN
	
func close():
	close_timer.start(close_delay)
	state = DoorState.CLOSING
	

func _on_safe_area_body_entered(body: Node2D) -> void:
	can_close = false
	bodies_stack.push_back(body)

func _on_safe_area_body_exited(body: Node2D) -> void:
	bodies_stack.erase(body)
	if len(bodies_stack) > 0: return # still overlapping bodies
	can_close = true
	if state == DoorState.CLOSING and close_timer.is_stopped():
		state = DoorState.CLOSED

func _on_close_timer_timeout() -> void:
	if not can_close:
		return
	state = DoorState.CLOSED

func trigger_with_btn(state: String):
	if state == "pressed":
		open()
	elif state == "released":
		close()
