extends Control

func _unhandled_input(event: InputEvent) -> void:
	if event.is_pressed():
		Global.game_controller.restart_chapter()
