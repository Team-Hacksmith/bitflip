extends Node2D

signal btn_pressed(body: Node2D)
signal btn_released(body: Node2D)

var is_pressed: bool = false
var bodies_stack: Array[Node2D] = []
@onready var sprite_2d: Sprite2D = $Sprite2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	#print(body.name)
	bodies_stack.push_back(body)
	is_pressed = true
	btn_pressed.emit(body)
	sprite_2d.frame = 1

func _on_area_2d_body_exited(body: Node2D) -> void:
	bodies_stack.erase(body)
	if len(bodies_stack) > 0: return # A body is still pressing the btn
	is_pressed = false
	btn_released.emit(body)
	sprite_2d.frame = 0
