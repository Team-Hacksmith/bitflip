@tool
class_name Laser
extends Line2D

signal player_hit

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

@export var is_on: bool = true:
	set(new):
		is_on = new
		if not animation_player: return new
		if is_on:
			animation_player.play_backwards("turn_off")
		else:
			animation_player.play("turn_off")
			
@export var time_based: bool = false
@export var toggle_time := 4.0

@export_group("Debug")
@export var update_laser: bool:
	set(new):
		_update_laser()
		update_configuration_warnings()
		
@export var keep_updating_laser_for_debug: bool

@onready var timer: Timer = $Timer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var area_2d: Area2D = $Area2D

var is_player_inside = false

func _ready() -> void:
	timer.wait_time = toggle_time + .2
	_update_laser()
	if not Engine.is_editor_hint():
		_setup_collision()

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

func _setup_collision():
	for i in points.size() - 1:
		var new_shape = CollisionShape2D.new()
		area_2d.add_child(new_shape)
		var rect = RectangleShape2D.new()
		new_shape.position = (points[i] + points[i + 1]) / 2
		new_shape.rotation = points[i].direction_to(points[i + 1]).angle()
		var length = points[i].distance_to(points[i + 1])
		rect.extents = Vector2(length / 2, 4)
		new_shape.shape = rect

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Engine.is_editor_hint() and keep_updating_laser_for_debug:
		_update_laser()

func _get_configuration_warnings():
	var warnings = []

	if not node_a or not node_b:
		warnings.append("Laser must have Node A and Node B assigned")

	return warnings


func _on_timer_timeout() -> void:
	is_on = !is_on
	if is_player_inside and is_on:
		player_hit.emit()
		print("player already in laser")


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_player_inside = true
		if is_on:
			player_hit.emit()
			print("player hit laser")


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_player_inside = false
