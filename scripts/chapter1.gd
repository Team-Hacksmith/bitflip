extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Dialogic.start("RoombaWakeUp")
	Global.player_stats.add_part(0) # speed
	Global.player_stats.add_part(1) # jump
	Global.player.apply_abilities()

func _on_player_ready(player: Player):
	print(player.name)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
