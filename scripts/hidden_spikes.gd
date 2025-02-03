extends Node2D

@export var time_based: bool = true
@export var hidden_time = 4
@export var active_time = 1
@export var state: SpikeState = SpikeState.HIDDEN:
	set(new):
		if not sprite: return
		state = new
		_on_state_change(state)
@onready var timer: Timer = $Timer
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

enum SpikeState {
	HIDDEN,
	ACTIVE,
}


func _ready() -> void:
	_on_state_change(state)
	if time_based:
		timer.start()
	else:
		timer.stop()


func _on_state_change(new_state: SpikeState):
	match new_state:
		SpikeState.HIDDEN:
			sprite.play_backwards("default")
			$DeadZone.disabled = true
			timer.wait_time = active_time
		SpikeState.ACTIVE:
			sprite.play("default")
			$DeadZone.disabled = false
			timer.wait_time = hidden_time


func _on_timer_timeout() -> void:
	if state == SpikeState.HIDDEN:
		state = SpikeState.ACTIVE
	elif state == SpikeState.ACTIVE:
		state = SpikeState.HIDDEN
