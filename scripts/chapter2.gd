extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.player_stats.add_part(0, false) # speed
	#Global.player_stats.add_part(1) # jump
	Global.player.apply_abilities()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
