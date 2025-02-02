extends Control

var is_done: bool = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_pressed() and not is_done:
		is_done = true
		Global.game_controller.restart_chapter()
