@tool
class_name Laser
extends Line2D

@export var node_a: Node2D:
	set(new):
		node_a = new
		update_configuration_warnings()
		return new
		
@export var node_b: Node2D:
	set(new):
		node_b = new
		update_configuration_warnings()
		return new

@export var is_on: bool = false
			
#@export var time_based: bool = false
@export var toggle_time := 4.0
@export var on_time := 3.0
@export var off_time := 3.0

@export_group("Debug")
@export var show_debug_label: bool = false
@export var update_laser: bool:
	set(new):
		_update_laser()
		update_configuration_warnings()
		
@export var keep_updating_laser_for_debug: bool

@onready var timer: Timer = $Timer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var debug_label: Label = %DebugLabel
@onready var dead_zone: DeadZone = $DeadZone

var is_player_inside = false

func _ready() -> void:
	timer.start(get_wait_time())
	_update_laser()
	if not Engine.is_editor_hint():
		_setup_collision()

func get_wait_time():
	if is_on:
		return on_time
	else: 
		return off_time

func toggle_laser():
	if is_on:
		animation_player.play("turn_off")
		await animation_player.animation_finished
		is_on = false
		dead_zone.disabled = true
	else:
		is_on = true
		dead_zone.disabled = false
		animation_player.play_backwards("turn_off")

func _update_laser():
	#print(node_a, node_b)
	assert(node_a, "Laser must have node A")
	assert(node_b, "Laser must have node B")
	if len(points) <= 0:
		add_point(node_a.position)
		add_point(node_b.position)
	elif len(points) == 2:
		points[0] = node_a.position
		points[1] = node_b.position
	else:
		clear_points()
		add_point(node_a.position)
		add_point(node_b.position)
	if show_debug_label:
		debug_label.global_position = node_a.global_position
		debug_label.show()
	else:
		debug_label.hide()

func _setup_collision():
	for i in points.size() - 1:
		var new_shape = CollisionShape2D.new()
		dead_zone.add_child(new_shape)
		var rect = RectangleShape2D.new()
		new_shape.position = (points[i] + points[i + 1]) / 2
		new_shape.rotation = points[i].direction_to(points[i + 1]).angle()
		var length = points[i].distance_to(points[i + 1])
		rect.extents = Vector2(length / 2, 4)
		new_shape.shape = rect

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		if keep_updating_laser_for_debug:
			_update_laser()
	if show_debug_label:
		debug_label.text = str(is_on) + "\n" + "%.2f" % timer.time_left

func _get_configuration_warnings():
	var warnings = []

	if not node_a or not node_b:
		warnings.append("Laser must have Node A and Node B assigned")

	return warnings


func _on_timer_timeout() -> void:
	await toggle_laser()
	timer.start(get_wait_time())
