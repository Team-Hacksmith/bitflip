class_name PlayerStats
extends Resource

signal damaged(amt: float)
signal healed(amt: float)
signal dead

@export var health: float = 100:
	set(new):
		if new > health:
			healed.emit(new - health)
		elif new < health:
			damaged.emit(health - new)
		health = clamp(new, 0, 100)
		if health == 0:
			dead.emit()
			Global.game_controller.change_gui_scene("res://gui/game_over.tscn")

@export var parts_obtained: Array[Global.BrokenParts] = []

@export var min_speed: int = 20
@export var max_speed: int = 30
@export var max_jump_force: int = 400

#@export var abilities: Abilities = preload("res://resources/default_player_abilities.tres")

func add_part(part: Global.BrokenParts):
	if part in parts_obtained:
		return
	parts_obtained.push_back(part)
		#match part:
			#Global.BrokenParts.WHEEL:
				#abilities.speed = true
			#Global.BrokenParts.SPRING:
				#abilities.jump = true
			#Global.BrokenParts.GUN:
				#abilities.gun = true
	print("Added part: ", part)
	print(parts_obtained)
