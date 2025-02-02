extends Node2D

signal btn_pressed(body: Node2D)
signal btn_released(body: Node2D)

@export var trigger_object: Node2D

var is_pressed: bool = false
var bodies_stack: Array[Node2D] = []
@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	if trigger_object:
		assert(
			trigger_object.has_method("trigger_with_btn"),
			"No trigger_with_btn Method found on object: " + trigger_object.name
		)
		

func _on_area_2d_body_entered(body: Node2D) -> void:
	#print(body.name)
	bodies_stack.push_back(body)
	is_pressed = true
	btn_pressed.emit(body)
	sprite_2d.frame = 1
	if trigger_object and trigger_object.has_method("trigger_with_btn"):
		trigger_object.trigger_with_btn("pressed")

func _on_area_2d_body_exited(body: Node2D) -> void:
	bodies_stack.erase(body)
	if len(bodies_stack) > 0: return # A body is still pressing the btn
	is_pressed = false
	btn_released.emit(body)
	sprite_2d.frame = 0
	if trigger_object and trigger_object.has_method("trigger_with_btn"):
		trigger_object.trigger_with_btn("released")
