extends Node2D

func _ready() -> void:
	Global.player_stats.add_part(0, false) # speed
	Global.player_stats.add_part(1) # jump
	Global.player_stats.add_part(2) # jump
	Global.player.apply_abilities()
