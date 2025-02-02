extends Node2D

signal btn_pressed(body: Node2D)
signal btn_released(body: Node2D)

var is_pressed: bool = false
@onready var sprite_2d: Sprite2D = $Sprite2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	print(body.name)
	is_pressed = true
	btn_pressed.emit(body)
	sprite_2d.frame = 1

func _on_area_2d_body_exited(body: Node2D) -> void:
	is_pressed = false
	btn_released.emit(body)
	sprite_2d.frame = 0
