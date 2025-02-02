class_name PlayerStats
extends Resource

signal damaged(amt: float)
signal healed(amt: float)
signal dead

@export var health : float = 100:
	set(new):
		if new > health:
			healed.emit(new - health)
		elif new < health:
			damaged.emit(health - new)
		health = clamp(new, 0, 100)
		if health == 0:
			dead.emit()
			Global.game_controller.change_gui_scene("res://gui/game_over.tscn")
