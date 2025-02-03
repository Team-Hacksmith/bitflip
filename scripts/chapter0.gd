extends Node2D

func _ready() -> void:
	Global.player_stats.add_part(Global.BrokenParts.WHEEL)
	Global.player_stats.add_part(Global.BrokenParts.SPRING)
	Global.player_stats.add_part(Global.BrokenParts.GUN)
	Global.player.apply_abilities()
