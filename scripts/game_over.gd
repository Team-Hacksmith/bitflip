extends Control

func _unhandled_input(event: InputEvent) -> void:
	if event.is_released():
		Global.game_controller.restart_chapter()
